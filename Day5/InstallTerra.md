# 🚀 Terraform Installation Guide

This guide provides instructions for installing **HashiCorp Terraform** on two popular Linux distributions: **Amazon Linux 2023** and **Ubuntu**.

## Prerequisites

* A user account with **sudo** privileges.
* An active internet connection.

---

## 1. Installation on Ubuntu (Recommended Method: HashiCorp Repository)

The most reliable way to install Terraform on Ubuntu is by using the official HashiCorp Linux repository. This ensures you get the latest stable version and can easily update.

### Steps:

1.  Update the package list and install necessary dependencies:

    ```bash
    sudo apt update
    sudo apt install -y software-properties-common wget
    ```
    <img width="1000" height="500" alt="Image" src="https://github.com/user-attachments/assets/56e7da6b-5b1b-49b7-84c4-ee41d998835f" />

2.  Download the HashiCorp GPG key:

    ```bash
    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
    ```
    <img width="1400" height="612" alt="Image" src="https://github.com/user-attachments/assets/3aae4d47-8198-41aa-8ed1-3be841298a4c" />

3.  Add the official HashiCorp repository:

    ```bash
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
    ```
    <img width="1932" height="376" alt="Image" src="https://github.com/user-attachments/assets/b5beaff7-e4a7-4c18-a0b7-f2d17ac29924" />

4.  Update and install Terraform:

    ```bash
    sudo apt update
    sudo apt install terraform
    ```
    <img width="1918" height="792" alt="Image" src="https://github.com/user-attachments/assets/760c5802-ef88-47cd-856d-6f179ce272aa" />

5.  Verify the installation:

    ```bash
    terraform --version
    ```
    <img width="1024" height="205" alt="Image" src="https://github.com/user-attachments/assets/617fc8cc-07f9-40ab-b2c1-96c96454d356" />

---
