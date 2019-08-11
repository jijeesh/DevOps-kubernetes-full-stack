
# resource "aws_ebs_volume" "aws-ebs-volume" {
#   availability_zone = "${var.availability_zone}"
#   size              = 1
#   tags {
#     Name = "${var.name}"
#     Environment = "${var.env}"
#     CreatedBy = "terraform"
#   }
# }

locals {
  # The default username for our AMI
  vm_user = "${var.vm_user}"
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}


resource "aws_instance" "aws-instance" {
    ami           = "${var.ami_id}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    availability_zone = "${var.availability_zone}"
    associate_public_ip_address = true
    security_groups = ["${aws_security_group.aws-security-group.name}"]


    tags {
      Name = "${var.name}"
      Environment = "${var.env}"
      CreatedBy = "terraform"
    }
    provisioner "remote-exec" {
      # The connection will use the local SSH agent for authentication
      inline = ["echo Successfully connected"]

      # The connection block tells our provisioner how to communicate with the resource (instance)
      connection {
        user = "${local.vm_user}"
      }
    }
    provisioner "local-exec" {
      command = <<EOT
        echo [defaults] > ansible.cfg;
        echo hostfile = inventory-${var.env} >> ansible.cfg;
        echo host_key_checking = False >> ansible.cfg;
        echo private_key_file = ~/.ssh/${var.key_name}.pem >> ansible.cfg;
        echo deprecation_warnings=False >> ansible.cfg;
        echo #gathering = smart >> ansible.cfg;
        echo #fact_caching = jsonfile >> ansible.cfg;
        echo #fact_caching_connection = /tmp/facts_cache >> ansible.cfg;
        echo #fact_caching_timeout = 7200 >> ansible.cfg;
        echo forks = 100 >> ansible.cfg;
        echo bin_ansible_callbacks=True >> ansible.cfg;
        echo connection_plugins = ../ansible/connection_plugins >> ansible.cfg;
        echo [ssh_connection] >> ansible.cfg;
        echo pipelining = True >> ansible.cfg;
        echo control_path = /tmp/ansible-ssh-%%h-%%p-%%r >> ansible.cfg;
        echo [${var.env}] > inventory-${var.env};
        echo ${aws_instance.aws-instance.public_ip} ansible_python_interpreter=/usr/bin/python3 >> inventory-${var.env};
        ansible-playbook -s main.yml
        EOT
      on_failure = "continue"
    }



    # This is where we configure the instance with ansible-playbook

    provisioner "local-exec" {

      #command = "echo ${aws_instance.jenkins_master.public_ip} >> ${var.env}"
        # command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${local.vm_user}  -i '${aws_instance.aws-instance.public_ip},' -e 'ansible_python_interpreter=/usr/bin/python3' master.yml"
        command = "ansible-playbook -s main.yml"
    }
}

# resource "aws_volume_attachment" "aws-volume-attachment" {
#   device_name = "/dev/sdh"
#   volume_id   = "${var.dokcer_volume_id}"
#   instance_id = "${aws_instance.aws-instance.id}"
# }
# resource "aws_volume_attachment" "aws-jenkins-volume-attachment" {
#   device_name = "/dev/sdi"
#   volume_id   = "${var.jenkins_volume_id}"
#   instance_id = "${aws_instance.aws-instance.id}"
# }


# resource "null_resource" "ansible" {
#     provisioner "local-exec" {
#       command = <<EOT
#       ansible-playbook -s main.yml
#         EOT
#       on_failure = "continue"
#     }
#     depends_on = ["aws_instance.aws-instance"]
# }
output "public_ip" {
  value = "${aws_instance.aws-instance.public_ip}"
}
