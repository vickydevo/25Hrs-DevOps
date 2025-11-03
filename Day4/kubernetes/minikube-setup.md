# Minikube Setup Guide

This guide provides step-by-step instructions to set up Minikube on a Linux system.

## Prerequisites
- Ensure you have `sudo` privileges on your system.
- Install `curl` if not already installed.

### Step 3: Install Required Packages
```bash
sudo yum install git maven docker java-17-amazon-corretto -y 
sudo apt update && sudo apt install git maven docker.io openjdk-17-jdk -y
```


### Step 4: Start and Verify Docker Service
```bash
sudo systemctl start docker
sudo systemctl status docker
```

### Install Docker and Add User to Docker Group
1. Install Docker:
  ```bash
  sudo yum install docker -y && sudo usermod -aG docker $USER && newgrp docker
  ```

2. Verify Docker installation:
  ```bash
  docker --version
  ```

## Steps

### Step 1: Download and Install Minikube
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64
```

### Step 2: Verify Minikube Installation
```bash
minikube status
```


### Step 5: Install `kubectl`
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
```

#### Add `kubectl` to PATH
Edit your shell profile file (e.g., `~/.bashrc`):
```bash
nano ~/.bashrc
```
Add the following line at the end:
```bash
export PATH="$HOME/.local/bin:$PATH"
```
Reload the shell profile:
```bash
source ~/.bashrc
```

### Step 6: Verify `kubectl` Installation
```bash
kubectl version --client
kubectl version --client --output=yaml
```

### Step 7: Start Minikube with Docker Driver
```bash
minikube start --driver=docker
```
**![Image](https://github.com/user-attachments/assets/f513eea3-79dd-49d3-beca-1c25e23fe1d9)**

```bash
minikube status
```
***![Image](https://github.com/user-attachments/assets/29cb950f-b7e7-4e87-8e95-2e384d1b2c62)***
 

### Step 8: Verify All Workloads Managed by Kubernetes

To list all workloads managed by Kubernetes, including Deployments, StatefulSets, DaemonSets, ReplicaSets, Jobs, CronJobs, and Pods, run the following command:

```bash
kubectl get all
```

### Explicitly List All Workload Types

To explicitly list all workload types with detailed information, use the following command:

```bash
kubectl get deployments,replicasets,jobs,cronjobs,pods,statefulsets,daemonsets
kubectl get all --show-kind --output=wide
```

### Step 10: Access Kubernetes Dashboard
Start the dashboard:
```bash
minikube dashboard
```
***![Image](https://github.com/user-attachments/assets/ba58d8b7-8537-440e-b0d3-c5c0b753dc93)***
For external access, in another client/terminal  set up a proxy:
```bash
kubectl proxy --address='0.0.0.0' --accept-hosts='^*$'
```
**![Image](https://github.com/user-attachments/assets/a666d12b-a143-413a-b30e-c4b6812c897a)**

Access the dashboard in your browser:
```
http://<your-ec2-public-ip>:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
```
**![Image](https://github.com/user-attachments/assets/6d1c8d8e-cfac-43fe-b52f-6ae646e7e3b4)**

### Step 9: Deploy Application with NodePort Service

To deploy an application using a manifest file with a NodePort service and access it in your browser, follow these steps:

1. Create a manifest file (e.g., `nodeport-service.yml`) with the following content:
  ```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: nginx
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
spec:
  type: NodePort
  selector:
    app: my-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30007

  ```

2. Apply the manifest file:
  ```bash
  kubectl apply -f nodeport-service.yml
  ```
**![Image](https://github.com/user-attachments/assets/2ba8953c-665a-449d-87bd-a3cef5167e29)**
3. Verify the deployment and service:
  ```bash
  kubectl get deployments
  kubectl get services
  ```

4. Access the application in your browser:
  - Use the Minikube IP:
    ```bash
    minikube ip
    ```
  - Open the following command in your in ec2 instance :
    ```
    curl http://<minikube-ip>:30007
    ```
**![Image](https://github.com/user-attachments/assets/502b37a2-beb0-4a48-96be-1c8b76bdd597)**
You should see the default Nginx welcome page.

### Step 9.1: Access NodePort Service on EC2 Instance

Since Minikube is running inside an EC2 instance, the NodePort service won't be directly accessible via the EC2 public IP. Follow these steps to access the service:

1. **Enable Port Forwarding on Minikube**  
  Use the `kubectl port-forward` command to forward the NodePort service to a local port on the EC2 instance:
  ```bash
  kubectl port-forward service/my-app-service 8080:80
  ```
  **![Image](https://github.com/user-attachments/assets/f0f8c1a0-9007-4b27-bced-e4131f508468)**

2. **Access the Service Locally on EC2**  
  Open a browser or use `curl` on the EC2 instance to access the service:
  ```bash
  curl http://localhost:8080
  ```
**![Image](https://github.com/user-attachments/assets/1f54873e-b4fd-48b2-9088-a033a9f45cb6)**
3. **Access the Service Externally**  
  To access the service from your local machine, set up an SSH tunnel to the EC2 instance:
  ```bash
  ssh -i <your-key.pem> -L 8080:localhost:8080 ec2-user@<your-ec2-public-ip>
  ```
**![Image](https://github.com/user-attachments/assets/4dbf90a6-59c7-475d-98d5-634610d3d996)**
  Then, open your browser and navigate to:
  ```
  http://localhost:8080
 
  ```
**![Image](https://github.com/user-attachments/assets/a6b8af38-f041-44ce-895b-09e782d14dce)**
This setup allows you to access the NodePort service running inside Minikube on the EC2 instance from your local machine.

### Step 9.2: Access NodePort Service Using Minikube Tunnel

Alternatively, you can expose the NodePort service using an SSH tunnel directly to the Minikube IP. Follow these steps:

1. **Set Up an SSH Tunnel**  
  Use the following command to create an SSH tunnel from your local machine to the Minikube IP:
  ```bash
  ssh -i private.pem -L 8081:192.168.49.2:30007 ubuntu@54.161.50.57
  ```
  **![Image](https://github.com/user-attachments/assets/999c525f-6791-4e51-a4b8-6e8c5a24db54)**

2. **Access the Service Locally**  
  Open your browser or use `curl` on your local machine to access the service:
  ```bash
  curl http://localhost:8081
  ```

This method allows you to directly access the NodePort service running inside Minikube from your local machine without additional port forwarding steps.
### Request Workflow: Browser to NGINX Container

The following diagram illustrates the request workflow from your local browser to the NGINX container running inside Kubernetes on Minikube:

```
Browser (local machine)
  ↓
localhost:8081
  ↓ (via SSH tunnel)
EC2 instance 8080
  ↓
Minikube IP 192.168.49.2:30007
  ↓
NGINX container inside Kubernetes
```

This setup ensures secure access to the NodePort service running inside Minikube from your local machine.
