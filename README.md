# DevOps-kubernetes-full-stack
 I will illustrate how I deployed a Kubernetes cluster on AWS using kubespray.

# PREREQUISITES
1. python, pip, git, ansible, terraform
2. AWS IAM user and access key
3. AWS EC2 key pair

## Latest Releases via Apt (Ubuntu)
To configure the PPA on your machine and install ansible run these commands:
```
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```
## INSTALL TERRAFORM
```
sudo apt-get install python-pip wget unzip
wget https://releases.hashicorp.com/terraform/0.12.6/terraform_0.12.6_linux_amd64.zip
sudo unzip ./terraform_0.12.6_linux_amd64.zip -d /usr/local/bin/
terraform -v
```
# DOWNLOAD THE KUBESPRAY REPO LATEST
```
wget https://github.com/kubernetes-sigs/kubespray/archive/v2.10.4.tar.gz
tar -xzf v2.10.4.tar.gz
mv kubespray-2.10.4/ kubespray
rm v2.10.4.tar.gz
```
## INSTALL THE REQUIRED PYTHON MODULES
```
cd kubespray
sudo pip install -r requirements.txt
```
