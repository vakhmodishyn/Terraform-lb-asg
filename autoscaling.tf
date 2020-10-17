terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  profile = "admin"
  region  = var.region
}



# Create the Security Group for instances
resource "aws_security_group" "instance" {
  name        = "pay-instance"
  description = "default VPC security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["76.169.181.0/24"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["35.198.162.0/24"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# Create aws launch configuration for the Autoscaling Group
resource "aws_launch_configuration" "PlayQ-2019" {
  image_id          = lookup(var.ami, var.region)
  instance_type     = "t2.micro"
  key_name          = "webservers"
  user_data         = filebase64("${path.module}/userdata.sh")
  security_groups   = [aws_security_group.instance.id]
  enable_monitoring = false
}



# Create the Auto Scaling group
resource "aws_autoscaling_group" "PlayQ2019" {
  name                 = "PlayQ-2019"
  launch_configuration = aws_launch_configuration.PlayQ-2019.name
  min_size             = 1
  max_size             = 1
  vpc_zone_identifier  = [var.subnet]
  #depends_on = [aws_lb_target_group.PlayQ-2019]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "PlayQ-2019"
  }

  tag {
    key                 = "type"
    propagate_at_launch = true
    value               = "webserver"
  }
}


# Attach autoscaling to load balancer
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.PlayQ2019.id
  alb_target_group_arn   = aws_lb_target_group.PlayQ-2019.id
}