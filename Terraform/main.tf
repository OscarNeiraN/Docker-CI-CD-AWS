terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

resource "aws_security_group" "seguridadServidor" {
  name   = "seguridadServidor"
  vpc_id = data.aws_vpc.default_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "key_servidor" {
  key_name   = "key_servidor"
  public_key = file("${path.module}/key_pars/key_servidor.pub")
}

data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "servidor_docker" {
  ami                         = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type               = "t2.micro"
  key_name                    = "key_servidor"
  subnet_id                   = data.aws_subnets.default_subnet.ids[0]
  vpc_security_group_ids      = [aws_security_group.seguridadServidor.id]
  associate_public_ip_address = true
  user_data                   = filebase64("./script.sh")
  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true
  }
  tags = {
    name = "servidorDocker"
  }

}

output "public_ip" {
  value = aws_instance.servidor_docker.public_ip
}