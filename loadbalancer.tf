# Create Security Group for Load Balancer
resource "aws_security_group" "balancer" {
  name        = "pay-balancer"
  description = "default VPC security group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# Create the Application Load Balancer for our Autoscaling Group “PlayQ-2019"
resource "aws_lb" "PlayQ-2019" {
  name               = "PlayQ-2019"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.balancer.id]
  #subnets = [var.subnet]
  access_logs {
    bucket = "test"
  }
  subnet_mapping {
    subnet_id = var.subnet
  }
subnet_mapping {
    subnet_id = var.subnet2
  }
}

resource "aws_lb_target_group" "PlayQ-2019" {
  name     = "PlayQ-2019"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc
}


resource "aws_lb_listener" "PlayQ-2019" {
  load_balancer_arn = aws_lb.PlayQ-2019.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "500"
    }
  }
}

