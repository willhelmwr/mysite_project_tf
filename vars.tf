variable "AWS_REGION" {
  default = "eu-central-1"
}

variable "AWS_AZ" {
  default = "eu-central-1a"
}

variable "AMI" {
  type = map(string)

  default = {
    eu-central-1 = "ami-0681fc5bcb91004e5"
  }
}

variable "PUBLIC_KEY_PATH" {
  default = "./rmaty-key-pair.pub"
}

variable "PRIVATE_KEY_PATH" {
  default = "./rmaty-key-pair"
}

variable "EC2_USER" {
  default = "ec2-user"
}