/*  
# This part works fine
data "template_file" "shell-script" {
  template = "${file("scripts/apt-get.sh")}"
}
*/

# Declare the script for master
data "template_file" "master-shell-script" {
  template = "${file("scripts/k8s-master.sh")}"
}

# Declare the script for nodes
data "template_file" "node-shell-script" {
  template = "${file("scripts/k8s-node.sh")}"
}
/*
part {
  content_type = "text/x-shellscript"
  content      = "${data.template_file.shell-script.rendered}"
}
*/
