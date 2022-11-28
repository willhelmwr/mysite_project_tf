resource "aws_vpc" "django-vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_support   = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name

  instance_tenancy = "default"

  tags = {
    Name = "rmaty-app"
  }
}

resource "aws_subnet" "django-subnet-public-1" {
  vpc_id                  = aws_vpc.django-vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone       = var.AWS_AZ
  tags = {
    Name = "rmaty-subnet-public-1"
  }
}

resource "aws_instance" "django-web" {
  ami           = lookup(var.AMI, var.AWS_REGION)
  instance_type = "t2.micro"
  # VPC
  subnet_id = aws_subnet.django-subnet-public-1.id
  # Security Group
  vpc_security_group_ids = ["${aws_security_group.ssh-allowed.id}"]
  # the Public SSH key
  key_name = aws_key_pair.rmaty-key-pair.id

  # nginx installation
  provisioner "file" {
    source      = "nginx.sh"
    destination = "/tmp/nginx.sh"

    connection {
      user        = var.EC2_USER
      private_key = file(var.PRIVATE_KEY_PATH)
      host        = self.public_ip
    }
  }
  provisioner "remote-exec" {

    connection {
      user        = var.EC2_USER
      private_key = file(var.PRIVATE_KEY_PATH)
      host        = self.public_ip
    }

    inline = [
      "chmod +x /tmp/nginx.sh",
      "sudo /tmp/nginx.sh"
    ]
  }
}
// Sends your public key to the instance
resource "aws_key_pair" "rmaty-key-pair" {
  key_name   = "rmaty-key-pair"
  public_key = file(var.PUBLIC_KEY_PATH)
}
