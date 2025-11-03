# Deploying an EKS Cluster

## Prerequisites
1. **Create an IAM Role**
   - Ensure that you have an IAM role with **EKS** or **Administrator** permissions.

2. **Create an Ubuntu EC2 Instance**
   - Launch an Ubuntu EC2 instance.
   - Attach the IAM role created above to the EC2 instance.

## Install Required Packages

### Update and Install Required Utilities
```sh
sudo apt update && sudo apt install unzip -y
```

### Install AWS CLI (Latest Version)
```sh
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### Install eksctl
```sh
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin/
```

### Install kubectl
```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin/
chmod +x /usr/local/bin/kubectl
```

## Create an EKS Cluster
```sh
eksctl create cluster --name "mycluster" --version 1.28 \
--zones=us-east-1a,us-east-1b,us-east-1c --without-nodegroup
```

### Associate IAM OIDC Provider
```sh
eksctl utils associate-iam-oidc-provider \
--region us-east-1 --cluster mycluster --approve
```

## Create a Node Group
```sh
eksctl create nodegroup --cluster=mycluster --region=us-east-1 \
--name=mycluster-ng-1 --node-type=t2.micro \
--nodes=2 --nodes-min=2 --nodes-max=4 --node-volume-size=20 \
--ssh-access --ssh-public-key=guntur \
--managed --asg-access --external-dns-access --full-ecr-access \
--appmesh-access --alb-ingress-access
```

## Cluster and Node Management

### Get Cluster Information
```sh
eksctl get clusters
```

### Get Node Group Information
```sh
eksctl get nodegroup --cluster mycluster
```

### Delete Node Group
```sh
eksctl delete nodegroup --cluster mycluster --name mycluster-ng-1
```

### Delete EKS Cluster
```sh
eksctl delete cluster --name=mycluster
```

