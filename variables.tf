variable "instance_type" {
	type = string
	default = "t2.micro"
	description = "My instance type, just practice variables"
}

variable "ssh_user" {
  description = "SSH user name to connect to your instance."
  default     = "ubuntu"
}

variable "private_key_name" {
  description = "the file name on the key to the instance for example k.pem"
  default   = "k"
}

variable "key_path" {
	description = "self explanatory, example \"C:\\Users\\Administrator\\Desktop\\key.pem\" "
	default = "C:\\Users\\Administrator\\Desktop\\devExp\\Class 12\\extra\\k.pem"
}


