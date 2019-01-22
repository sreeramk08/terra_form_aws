/* 

  Declare the variables that can be used in this terraform configuration


variable "region" {
  type = "string"
  default = "us-west-2"
}

*/

/*
  
  Provider specification in file called provider.tf

*/

/*

 Security group modification

*/

resource "aws_security_group" "k8s-nodes-group" {
  id = "sg-02872193b06c56e74"
  name = "nodes.ss8cluster.k8s.local"
  vpc_id = "vpc-02ad0a698710ca515"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["205.172.229.252/32"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}
