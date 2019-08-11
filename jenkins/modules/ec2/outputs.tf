output "address" {
  value = "${aws_instance.aws-instance.public_ip}"
}

output "ssh" {
  value = "ssh ${local.vm_user}@${aws_instance.aws-instance.public_ip}"
}
