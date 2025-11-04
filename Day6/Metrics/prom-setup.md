# 🛠️ Observability Setup on Minikube with Helm

This guide details the steps to deploy the **`kube-prometheus-stack`** (Prometheus, Grafana, Alertmanager) onto a **Minikube** cluster running on an Ubuntu EC2 instance using **Helm 3**.

## Prerequisites

Before starting, ensure you have:

  * An active **Minikube** cluster running on your Ubuntu EC2 instance.
  * **`kubectl`** installed and configured to communicate with Minikube (`kubectl config current-context` should show `minikube`).

-----

## ⚙️ Installation & Configurations

### 🧰 Step 1: Install Helm 3

Since Helm is not available, you must install it first.

```bash
# Download and install Helm 3
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Verify installation
helm version
```

### 📦 Step 2: Add Prometheus Helm Repository

Add the community chart repository and update your local chart list.

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### 🚀 Step 3: Deploy the Chart

Deploy the chart into a new namespace called **`monitoring`**.

```bash
# Create the dedicated namespace
kubectl create ns monitoring

# Deploy the kube-prometheus-stack using default values
# If you have a custom values file, use: 
# helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring -f ./custom_kube_prometheus_stack.yml
helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring
```

-----

## ✅ Verification and Access

### 🔎 Verify the Installation

Check that all necessary components are running in the `monitoring` namespace.

```bash
kubectl get all -n monitoring
```

### 🖥️ Accessing UIs via Port Forwarding

Since this is running on an EC2 instance, we use `--address 0.0.0.0` to make the forwarded port accessible via the **EC2 Public IP address**. **Ensure your EC2 Security Group allows inbound traffic on ports 8080, 9090, and 9093.**

  * **Grafana UI (Default Password: `prom-operator`)**

    ```bash
    kubectl port-forward service/monitoring-grafana -n monitoring 8080:80 --address 0.0.0.0
    ```

    Access URL: `http://<EC2-Public-IP>:8080`

  * **Prometheus UI**

    ```bash
    kubectl port-forward service/monitoring-kube-prometheus-prometheus -n monitoring 9090:9090 --address 0.0.0.0
    ```

    Access URL: `http://<EC2-Public-IP>:9090`

  * **Alertmanager UI**

    ```bash
    kubectl port-forward service/alertmanager-operated -n monitoring 9093:9093 --address 0.0.0.0
    ```

    Access URL: `http://<EC2-Public-IP>:9093`

> **Note:** Keep the terminal sessions running for the port-forwarding commands active.

-----

## 🧼 Clean Up

To remove all deployed resources:

```bash
# 1. Uninstall Helm chart
helm uninstall monitoring --namespace monitoring

# 2. Delete namespace
kubectl delete ns monitoring

# 3. Stop and Delete Minikube Cluster
minikube stop
minikube delete
```

-----

Would you like to explore how to configure **resource requests/limits** specifically for the Minikube environment by creating that optional custom values file?