// Create the VPC
resource "aws_vpc" "vpc" {
  #cidr_block = "10.0.0.0/16"
  default = true
  # cidr_block           = "${var.vpc_cidr}"
  # enable_dns_support   = "${var.enable_dns_support}"
  # enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags {
    Name = "${var.name}"
    Environment =  "${var.env}"
    CreatedBy = "terraform"
  }

}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}
