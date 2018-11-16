/* 

  Declare the variables that can be used in this terraform configuration

*/

variable "region" {
  type = "string"
  default = "us-west-2"
}

/*
  
  Provider specification

*/

provider "aws" {
  region = "${var.region}"
}

/*

  Declaration for creating the master (in the absence of a auto scaling)


resource "aws_instance" "k8s_master_instance" {
  ami = "ami-0091e5332008c5c0a"
  instance_type = "t2.micro"
  # Security group is created below
  security_groups = ["k8s-sg"]
  #user_data = <<-EOF
  #            #!/bin/bash
  #            echo "Hello world!" > index.html
  #            nohup busybox httpd -f -p "${var.server_port}" &
  #            EOF

  tags {
    Name = "kubernetes-master-${var.region}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

*/

/*

  Declaration for creating the nodes (in the absence of auto scaling)


resource "aws_instance" "k8s_nodes_instance" {
  ami = "ami-0091e5332008c5c0a"
  instance_type = "t2.micro"
  # Security group is created below
  security_groups = ["k8s-sg"]
  #user_data = <<-EOF
  #            #!/bin/bash
  #            echo "Hello world!" > index.html
  #            nohup busybox httpd -f -p "${var.server_port}" &
  #            EOF
  tags {
    Name = "kubernetes-nodes"
  }

  lifecycle {
    create_before_destroy = true
  }
}

*/

/*

 Security group declaration

*/

resource "aws_security_group" "k8s_sec_group" {
  name = "k8s-sg"
  vpc_id = "vpc-41fa3c24"
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
  
  # Ignore if it already exists
  lifecycle {
    ignore_changes = ["k8s-sg"]
  }
}

/*

  Create a launch configuration for master

*/

resource "aws_launch_configuration" "k8s_master_launch_config" {
  name = "K8s Master launch config"
  image_id = "ami-0091e5332008c5c0a"
  instance_type = "t2.micro"
  security_groups = ["k8s-${var.region}-sg"]
  #user_data = <<-EOF
  #            #!/bin/bash
  #            echo "Hello, World" > index.html
  #            nohup busybox httpd -f -p "${var.server_port}" &
  #            EOF

  lifecycle {
    create_before_destroy = true
  }
}

/*

  Launch configuration for Nodes

*/

resource "aws_launch_configuration" "k8s_nodes_launch_config"{
  name = "K8s Node Launch config"
  image_id = "ami-05778fb400b30826f"
  instance_type = "t2.micro"
  security_groups = ["k8s-${var.region}-sg"]
  
  lifecycle {
    create_before_destroy = true
  }
}

/*

  Auto scaling groups based off the launch configurations

*/

/*

  Autoscaling for master

*/

resource "aws_autoscaling_group" "k8s_master_auto_scaling" {
  launch_configuration = "${aws_launch_configuration.k8s_master_launch_config.id}"
  min_size = 1
  max_size = 1
  availability_zones =  ["us-west-2a", "us-west-2b", "us-west-2c"] 
  tag {
    key = "Name"
    value = "k8s-master-instance-${var.region}"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

/*

  Auto scaling for nodes

*/
resource "aws_autoscaling_group" "k8s_nodes_auto_scaling" {
  launch_configuration = "${aws_launch_configuration.k8s_nodes_launch_config.id}"
  min_size = 2
  max_size = 5
  availability_zones =  ["us-west-2a", "us-west-2b", "us-west-2c"]
  tag {
    key = "Name"
    value = "k8s-node-instances-${var.region}"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

