# This tells which provider to use
provider "aws" {
  region = "us-west-2"

}

# Next is the AWS instance declaration
resource "aws_instance" "k8s_instance" {
  ami = "ami-0091e5332008c5c0a"
  instance_type = "t2.micro"
  # If the instance has to be added to existing sec groups
  security_groups = ["k8s-us-west-2-sg"]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello world!" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  tags {
    Name = "kubernetes-master-us-west-2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

####################################################
#####     Security group declaration
###################################################

# In case we need to create our own security group
resource "aws_security_group" "k8s_sec_group" {
  name = "k8s-us-west-2-sg"
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
  
  # Ignore if it already exists
  lifecycle {
    ignore_changes = ["k8s-us-west-2-sg"]
  }
}

# Create a launch configuration
resource "aws_launch_configuration" "k8s_launch_config" {
  image_id = "ami-0091e5332008c5c0a"
  instance_type = "t2.micro"
  security_groups = ["k8s-us-west-2-sg"]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

# Finally create the auto scaling group based off the launch configuration
resource "aws_autoscaling_group" "k8s_auto_scaling" {
  launch_configuration = "${aws_launch_configuration.k8s_launch_config.id}"
  min_size = 2
  max_size = 5
  availability_zones =  ["us-west-2a", "us-west-2b", "us-west-2c"] 
  tag {
    key = "Name"
    value = "k8s-instances"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}
