# Terraform configuration for AWS EC2 infrastructure

# ==========================================
# 1. TERRAFORM CONFIGURATION
# ==========================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# ==========================================
# 2. AWS PROVIDER
# ==========================================

provider "aws" {
  region = "ap-south-1"
}

# ==========================================
# 3. INPUT VARIABLES
# ==========================================

variable "ssh_allowed_cidr" {
  description = "Your public IP address in CIDR notation"
  type        = string
}

# ==========================================
# 4. GET DEFAULT VPC
# ==========================================

data "aws_vpc" "default" {
  default = true
}

# ==========================================
# 5. GET AMAZON LINUX 2023 AMI
# ==========================================

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ==========================================
# 6. SECURITY GROUP
# ==========================================

resource "aws_security_group" "web_sg" {
  name        = "ec2-web-security-group"
  description = "Allow HTTP and restricted SSH access"
  vpc_id      = data.aws_vpc.default.id

  # SSH Access - Restricted to your IP
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  # HTTP Access - Website
  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2-Web-Security-Group"
  }
}

# ==========================================
# 7. EC2 INSTANCE
# ==========================================

resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  key_name                    = "
# ==========================================
# 1. TERRAFORM CONFIGURATION
# ==========================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# ==========================================
# 2. AWS PROVIDER
# ==========================================

provider "aws" {
  region = "ap-south-1"
}

# ==========================================
# 3. INPUT VARIABLES
# ==========================================

variable "ssh_allowed_cidr" {
  description = "Your public IP address in CIDR notation"
  type        = string
}

# ==========================================
# 4. GET DEFAULT VPC
# ==========================================

data "aws_vpc" "default" {
  default = true
}

# ==========================================
# 5. GET AMAZON LINUX 2023 AMI
# ==========================================

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ==========================================
# 6. SECURITY GROUP
# ==========================================

resource "aws_security_group" "web_sg" {
  name        = "ec2-web-security-group"
  description = "Allow HTTP and restricted SSH access"
  vpc_id      = data.aws_vpc.default.id

  # SSH Access - Restricted to your IP
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  # HTTP Access - Website
  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2-Web-Security-Group"
  }
}

# ==========================================
# 7. EC2 INSTANCE
# ==========================================

resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  key_name                    = "EC2_SSH_PRIVATE_KEY"
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  # Install Apache automatically
  user_data = <<-EOF
    #!/bin/bash

    dnf update -y
    dnf install -y httpd

    systemctl enable httpd
    systemctl start httpd

    echo '<h1>Welcome to AWS EC2!</h1>' > /var/www/html/index.html
    echo '<p>Apache Web Server is running successfully.</p>' >> /var/www/html/index.html
  EOF

  tags = {
    Name        = "Terraform-Web-Server"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

# ==========================================
# 8. OUTPUTS
# ==========================================

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.web_server.id
}

output "ec2_public_ip" {
  description = "EC2 Public IP Address"
  value       = aws_instance.web_server.public_ip
}

output "ec2_public_dns" {
  description = "EC2 Public DNS"
  value       = aws_instance.web_server.public_dns
}

output "website_url" {
  description = "Website URL"
  value       = "http://${aws_instance.web_server.public_dns}"
}
"
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  # Install Apache automatically
  user_data = <<-EOF
    #!/bin/bash

    dnf update -y
    dnf install -y httpd

    systemctl enable httpd
    systemctl start httpd

    echo '<h1>Welcome to AWS EC2!</h1>' > /var/www/html/index.html
    echo '<p>Apache Web Server is running successfully.</p>' >> /var/www/html/index.html
  EOF

  tags = {
    Name        = "Terraform-Web-Server"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

# ==========================================
# 8. OUTPUTS
# ==========================================

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.web_server.id
}

output "ec2_public_ip" {
  description = "EC2 Public IP Address"
  value       = aws_instance.web_server.public_ip
}

output "ec2_public_dns" {
  description = "EC2 Public DNS"
  value       = aws_instance.web_server.public_dns
}

output "website_url" {
  description = "Website URL"
  value       = "http://${aws_instance.web_server.public_dns}"
}
