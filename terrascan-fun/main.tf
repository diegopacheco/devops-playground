provider "aws" {
  region = "us-east-1"
  access_key = "EXAMPLEACCESSKEY123"
  secret_key = "BAD_SECRET_KEY"
}

resource "aws_security_group" "open_sg" {
  name        = "open_sg"
  description = "Security Group with all ports open"

  ingress {
    description      = "Allow all inbound traffic"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = "insecure-open-bucket"
  acl    = "public-read-write"
}

resource "aws_db_instance" "unsecured_db" {
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  identifier           = "unsecured-db"
  username             = "admin"
  password             = "plaintextpassword"
  skip_final_snapshot  = true
  publicly_accessible  = true
  storage_encrypted    = false
  vpc_security_group_ids = [
    aws_security_group.open_sg.id
  ]
}