# Terraform ,EC2 & Docker-compose
This is a continuation of the project docker.compose4EC2 found in this repo: https://github.com/isaacTadela/docker.compose4EC2
Here I used terraform and i let the magic happen.
 

## Pre-requirements:
Configuring the AWS CLI
A pem Key (you can choose to create one for you with terraform but I chose not to)


## The basic commands for you to know:

look for providers blokc and download providers
```bash
	terraform init
```

a dry-run for testing(without geting to the cloud provider)
```bash
	terraform plan
```

create it (run plan first and ask for approvel)
```bash
	terraform apply
```

destroy it
```bash
	terraform destroy
```


## What this code will do?

Traform talks to the cloud provider you choose using the API with your credentials, 
setup all the environment you need and install whatever you want 


Create Security Group
  in the resource "aws_security_group" block
	
Launch a New EC2 Instance
  using the resource "aws_instance" block
  
SSH into the machine and install Docker and Docker-compose
  with the resource "null_resource" "Docker" block
  
Install and Run my code
  in the resource "null_resource" "install_myApp" block
  
  

And here you have it, all the power of Traform - all in one command	
```bash
	terraform apply
```


Don't forget to init first and add you privet pem key in the variables file
```bash
	terraform init
```


## Check it out
in the output you will get the public dns and ip of your instance
you can open your browser with the ip address on port 8080 and see the wordpress page


## Terminate instance
Do not forget to terminate the instances, time is money
```bash
	terraform destroy
```