# DevOps-kubernetes-full-stack
 I will illustrate how I deployed a Kubernetes cluster on AWS using kubespray.

# Prerequisites
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
## Install terraform
```
sudo apt-get install python-pip wget unzip
wget https://releases.hashicorp.com/terraform/0.12.6/terraform_0.12.6_linux_amd64.zip
sudo unzip ./terraform_0.12.6_linux_amd64.zip -d /usr/local/bin/
terraform -v
```
# Download the kubespray repo latest
```
wget https://github.com/kubernetes-sigs/kubespray/archive/v2.10.4.tar.gz
tar -xzf v2.10.4.tar.gz
mv kubespray-2.10.4/ kubespray
rm v2.10.4.tar.gz
```
## Install the required python modules
```
cd kubespray
sudo pip install -r requirements.txt
```
# Infrastructure Provisioning

## Configure AWS credentials

Export the variables for your AWS credentials
```
export AWS_ACCESS_KEY_ID="key-id"
export AWS_SECRET_ACCESS_KEY ="access-key"
export AWS_SSH_KEY_NAME="ssh key name"
export AWS_DEFAULT_REGION="aws region"
```
## Configure Terraform Variables

```
cd kubespray/contrib/terraform/aws
cp terraform.tfvars.example terraform.tfvars
```
Open the file and change any defaults particularly, the number of master, etcd, and worker nodes. You can change the master and etcd number to 1 for deployments that don’t need high availability. By default, this  will create:

Markup :  * VPC with 2 public and private subnets
          * Bastion Hosts and NAT Gateways in the Public Subnet
          * Three of each (masters, etcd, and worker nodes) in the Private Subnet
          * AWS ELB in the Public Subnet for accessing the Kubernetes API from the internet
          * Terraform scripts using CoreOS as base image.
## Apply the configuration

## Initialize terraform and create the plan.
```
# initialize the modules
terraform init
# Then create the plan.
terraform plan -out=kubernetes_plan
# Apply the generated plan to proceed with provisioning.
terraform apply kubernetes_plan
```
## Installing Kubernetes cluster with Cilium as CNI

Kubespray uses Ansible as its substrate for provisioning and orchestration. Once the infrastructure is created, you can run the Ansible playbook to install Kubernetes and all the required dependencies. Execute the below command in the kubespray directory, providing the correct path of the AWS EC2 ssh private key in ansible_ssh_private_key_file=<path to EC2 SSH private key file>

```
ansible-playbook -i ./inventory/hosts ./cluster.yml -e ansible_user=core -e bootstrap_os=coreos -e kube_network_plugin=cilium -b --become-user=root --flush-cache  -e ansible_ssh_private_key_file=<path to EC2 SSH private key file>
```
## Validate Cluster
o check if cluster is created successfully, ssh into the bastion host with the user core.
```
# Get information about the basiton host
cat ssh-bastion.conf
ssh -i ~/path/to/ec2-key-file.pem core@public_ip_of_bastion_host
```
Execute the commands below from the bastion host. If kubectl isn’t installed on the bastion host, you can login to the master node to test the below commands. You may need to copy the private key to the bastion host to access the master node.
```
kubectl get nodes
kubectl get pods -n kube-system
```
You should see that nodes are in Ready state and Cilium pods are in Running state

## Delete Cluster
```
cd contrib/terraform/aws
terraform destroy
```
wrapper script demo.sh will install all this steps using ansible

```
./demo.sh

```
