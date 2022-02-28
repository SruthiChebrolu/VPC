provider "aws" {
    profile = "default"
    region = "us-east-1"
}


## Create VPC ##
resource "aws_vpc" "terraform-vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-demo-vpc"
  }
}

output "aws_vpc_id" {
  value = "aws_vpc.terraform-vpc.id"
}


/*==== Subnets ======*/
/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.terraform-vpc.id}"
  tags = {
    Name        = "INTERNET_GATEWAY"
  }
}
/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}
/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${aws_subnet.public_subnet.id}"
  depends_on    = [aws_internet_gateway.ig]
  tags = {
    Name        = "NAT"
 
  }
}
/* Public subnet */
resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.terraform-vpc.id}"
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "PUBLIC_SUBNET"
  }
}


/* Private subnet */
resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.terraform-vpc.id}"
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name        = "PRIVATE_SUBNET"
  }
}


/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.terraform-vpc.id}"
  tags = {
    Name        = "PUBLIC_ROUTE_TABLE"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.terraform-vpc.id}"
  tags = {
    Name        = "PRIVATE_ROUTE_TABLE"
  }
}
resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.ig.id}"
}
resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
}
/* Route table associations */
resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "private" {
  subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.private.id}"
}



## Security Group##
resource "aws_security_group" "terraform_private_sg" {
  description = "Allow limited inbound external traffic"
  vpc_id      = "${aws_vpc.terraform-vpc.id}"
  name        = "terraform_ec2_private_sg"

  ingress {
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.terraform-vpc.cidr_block]
    from_port   = 22
    to_port     = 22
  }

ingress {
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.terraform-vpc.cidr_block]
    from_port   = 80
    to_port     = 80
  }

 ingress {
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.terraform-vpc.cidr_block]
    from_port   = 443
    to_port     = 443
  }


  egress {
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  tags = {
    Name = "ec2-private-sg"
  }
}



output "aws_security_gr_id" {
  value = "aws_security_group.terraform_private_sg.id"
}

resource "aws_instance" "public_ec2" {
    ami = "ami-033b95fb8079dc481"
    instance_type = "t2.micro"
    vpc_security_group_ids =  [ "${aws_security_group.terraform_private_sg.id}" ]
    subnet_id = "${aws_subnet.public_subnet.id}"
    key_name               = "ec2-sruthi"
    count         = 1
    associate_public_ip_address = true
    tags = {
      Name              = "Public_subnet_EC2"
      Environment       = "development"
      Project           = "TERRAFORM"
    }
}




resource "aws_instance" "private_ec2" {
    ami = "ami-033b95fb8079dc481"
    instance_type = "t2.micro"
  vpc_security_group_ids =  [ "${aws_security_group.terraform_private_sg.id}" ]
    subnet_id = "${aws_subnet.private_subnet.id}"
    key_name               = "ec2-sruthi"
    count         = 1
    associate_public_ip_address = true
    tags = {
      Name              = "Private_subnet_EC2"
      Environment       = "development"
      Project           = "TERRAFORM"
    }
}



