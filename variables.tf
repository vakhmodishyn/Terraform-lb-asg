variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc" {
  type    = string
  default = "vpc-f6e4158b"
}

variable "ami" {
  type = map
  default = {
    "us-east-1" = "ami-0947d2ba12ee1ff75"
    "us-east-2" = "ami-03657b56516ab7912"
  }
}

variable "vpc-sg" {
  type    = string
  default = "sg-0543e439a4c720568"
}

variable "subnet" {
  type    = string
  default = "subnet-da8a29fb"
}

variable "subnet2" {
  type = string
  default = "subnet-60ae0b06"
}


