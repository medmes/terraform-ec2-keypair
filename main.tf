# Minimum version required
terraform {
  required_version = ">= 0.12.0"
}

# AWS Availability Zone, London Region
provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

# Generate Key Pair ssh for EC2 instace
locals {
  public_key_filename  = "${var.path}/${var.key_name}.pub"
  private_key_filename = "${var.path}/${var.key_name}.pem"
}

resource "tls_private_key" "algorithm" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.algorithm.public_key_openssh
}
resource "local_file" "public_key_openssh" {
  count    = var.path != "" ? 1 : 0
  content  = tls_private_key.algorithm.public_key_openssh
  filename = local.public_key_filename
}

resource "local_file" "private_key_pem" {
  count    = var.path != "" ? 1 : 0
  content  = tls_private_key.algorithm.private_key_pem
  filename = local.private_key_filename
}

resource "null_resource" "chmod" {
  count      = var.path != "" ? 1 : 0
  depends_on = [local_file.private_key_pem]

  triggers = {
    key = tls_private_key.algorithm.private_key_pem
  }

  provisioner "local-exec" {
    command = "chmod 600 ${local.private_key_filename}"
  }
}

# AWS EC2 Instance
resource "aws_instance" "aws_ec2" {
  ami = "ami-05f37c3995fffb4fd"
  instance_type = "t2.micro"
  # referring to key pair 
  key_name = aws_key_pair.generated_key.key_name

  # attaching to security group, syntax: value-> [] provider.type.name.attribute: aws.typeOfResource.name
  vpc_security_group_ids = [aws_security_group.Instance.id]
  
  tags = {
      Name = "aws-ec2"
  }
}

# Opening port, Inbound 
resource "aws_security_group" "Instance" {
  name = "aws_ec2_instance"

     # Please restrict your ingress to only necessary IPs and ports.
     # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  ingress {
     # TLS (change to whatever ports you need)
     from_port   = 22
     to_port     = 22
     protocol    = "tcp"
     cidr_blocks     = ["0.0.0.0/0"]
   }
}