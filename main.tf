terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-3"
}

output "public_ip" {
	value = aws_instance.example_ec2.public_ip
}

output "public_dns" {
	value = aws_instance.example_ec2.public_dns
}


resource "aws_security_group" "example_security_group" {
  name = "example"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress { 
    from_port = 0 
    to_port = 0 
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
  } 
  
  tags = {
    Name = "main_sc"
  }
}


resource "aws_instance" "example_ec2" {
  # Ubuntu Server 18.04 - ami-0a0d71ff90f62f72a
  ami = "ami-0a0d71ff90f62f72a"
  instance_type 	= var.instance_type
  key_name        	= var.private_key_name
  security_groups 	= [aws_security_group.example_security_group.name]
	
  tags = {
    Name = "main ec2"
  }
  
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = var.ssh_user
      private_key = file(var.key_path)
      timeout     = "1m"
      agent       = false
    }
	
}


# Install Docker and Docker-compose:

resource "null_resource" "Docker" {
	depends_on	= [aws_instance.example_ec2]
    connection {
      type        = "ssh"
      host        = aws_instance.example_ec2.public_ip
      user        = var.ssh_user
      private_key = file(var.key_path)
      timeout     = "1m"
      agent       = false
    }
	provisioner "remote-exec" {
    inline = [	
		# Update Software Repositories
		"sudo apt update",
		"sudo apt upgrade -y",
		
		# Uninstall Old Versions of Docker
		"sudo apt-get remove docker docker-engine docker.io",
		
		# Install Docker on Ubuntu 18.04
		"sudo apt-get install docker.io docker-compose -y",
		
		# Start and Automate Docker
		"sudo systemctl start docker",
		"sudo systemctl enable docker",
        ]
    }
}


# get the file from git and run the docker-compose(sudo apt install mysql-client-core-5.7)

resource "null_resource" "install_myApp" {
    depends_on = [null_resource.Docker]
    connection {
      type        = "ssh"
      host        = aws_instance.example_ec2.public_ip
      user        = var.ssh_user
      private_key = file(var.key_path)
      timeout     = "1m"
      agent       = false
    }
	provisioner "remote-exec" {
    inline = [
		"git clone https://github.com/isaacTadela/docker.compose4EC2.git",
		"cd docker.compose4EC2/",
		"sudo docker-compose up -d"
        ]
    }
}
