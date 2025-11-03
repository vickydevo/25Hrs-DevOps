# Exposing and Accessing Your Application Externally

This guide explains how to expose your Kubernetes application externally using a NodePort service and how to access it from outside the cluster. In this example, the application is deployed on an EC2 instance and uses a NodePort service to expose the app.

---

## Prerequisites

- **Kubernetes Cluster:** Ensure you have a running Kubernetes cluster (e.g., on an EC2 instance).
- **Deployment & NodePort Service:** Your application is deployed with a Deployment and exposed via a NodePort Service.
- **YAML Configuration:** The NodePort service is configured to use:
  - **Service Port:** `8082`
  - **Container Port:** `8081`
  - **NodePort:** `30037`
- **External Access:** Your EC2 instance (or Kubernetes node) has a public IP address, and necessary firewall rules/security groups allow traffic on port `30037`.

---

## Step 1: Verify the NodePort Service

1. **List Services:**

   Run the following command to ensure your NodePort service is deployed:
   ```bash
   kubectl get svc

## 2. Check for Your Service:

You should see an output similar to:

```
NAME             TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
spring-svc-np    NodePort   10.101.40.189   <none>        8081:30037/TCP   5m
```

## Minikube Specifics:

When using minikube, the cluster’s internal IP (10.106.252.54) isn’t reachable from outside. Instead, run:
```
minikube ip
```
to get the minikube VM’s IP. For example, if it returns 192.168.49.2, then you should access your service at:
```
curl http://192.168.49.2:30037
```