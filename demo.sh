#!/bin/bash

basedir="$( cd "$(dirname "$0")" ; pwd -P )"

echo "Script name $0 resides in $basedir directory."

# crate key file
if [ ! -f "~/.ssh/MyKeyPair.pem" ]; then

  ssh-keygen -t rsa -b 4096 -f ~/.ssh/MyKeyPair.pem -q -P ''
  chmod 400 ~/.ssh/MyKeyPair.pem
  ssh-keygen -y -f ~/.ssh/MyKeyPair.pem > ~/.ssh/MyKeyPair.pub

fi

function jenkins() {
  cd jenkins/app-test/
  terraform init
  terraform plan -out=jenkins_plan
  terraform apply jenkins_plan -auto-approve
}
# create Jenkins server using terraform


function kubernetes-infrastructure() {
  cd kubespray/contrib/terraform/aws
  terraform init
  terraform plan -out=kubernetes_plan
  terraform apply kubernetes_plan -auto-approve
}



function kubernetes() {
  cd kubespray
  ansible-playbook -i ./inventory/hosts ./cluster.yml \
   -e ansible_user=core -e bootstrap_os=coreos \
   -e kubeconfig_localhost=true \
   -e kube_network_plugin=cilium -b --become-user=root \
   --flush-cache  \
   -e ansible_ssh_private_key_file=~/.ssh/MyKeyPair.pem
  cp inventory/artifacts/admin.conf ../jenkins/ansible/roles/jenkins/files/admin.conf
}
kubernetes-infrastructure
kubernetes
jenkins
