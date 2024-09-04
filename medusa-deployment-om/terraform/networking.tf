 #networking.tf 

resource "aws_vpc" "medusa_vpc" {
  cidr_block = "10.0.0.0/16"
 }

resource "aws_subnet" "medusa_subnet" {
  vpc_id     = aws_vpc.medusa_vpc.id
  cidr_block = "10.0.1.0/24"
 }

resource "aws_secutiry_group" "medusa_sg" {
  vpc_id = aws_vpc.medusa_vpc.id 

  ingress {
    from_port   = 80
    to_port     = 80 
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432                                                    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port   = 0                                                       to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
