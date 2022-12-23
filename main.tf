provider "aws" {
  region = var.region
}

#resource "aws_default_vpc"  სახელად "default"

resource "aws_default_vpc" "default" {} 

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


#resource "aws_eip" სახელად "server_static_ip"

resource "aws_eip" "server_static_ip" {
  vpc      = true
  instance = aws_instance.web_server.id
  tags = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Server IP" })
}

#resource "aws_security_group"  სახელად "web_sec"

resource "aws_security_group" "web_sec" {
  name   = "web security group"
  vpc_id = aws_default_vpc.default.id

#წვდომა გაუხსენით SSH და HTTP პორტებზე  მხოლოდ

  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Server SecurityGroup" })


}


#resource "aws_instance  სახელად "web_server"

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sec.id]
  monitoring             = false
  user_data              = file("user_data.sh")
  tags = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Web Server" })
}


#output "server_static_ip"

output "my_server_ip" {
  value = aws_eip.server_static_ip.public_ip
}