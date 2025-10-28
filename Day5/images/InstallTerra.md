# 🚀 Terraform Installation Guide

This guide provides instructions for installing **HashiCorp Terraform** on two popular Linux distributions: **Amazon Linux 2023** and **Ubuntu**.

## Prerequisites

* A user account with **sudo** privileges.
* An active internet connection.

---

## 1. Installation on Ubuntu (Recommended Method: HashiCorp Repository)

The most reliable way to install Terraform on Ubuntu is by using the official HashiCorp Linux repository. This ensures you get the latest stable version and can easily update.

### Steps:

1.  **Update the package list and install necessary dependencies:**

    ```bash
    sudo apt update
    sudo apt install -y software-properties-common wget
    ```

2.  **Download the HashiCorp GPG key:**

    ```bash
    wget -O- [https://apt.releases.hashicorp.com/gpg](https://apt.releases.hashicorp.com/gpg) | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
    ```

3.  **Add the official HashiCorp repository:**

    ```bash
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    [https://apt.releases.hashicorp.com](https://apt.releases.hashicorp.com) $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
    ```

4.  **Update and install Terraform:**

    ```bash
    sudo apt update
    sudo apt install terraform
    ```

---
