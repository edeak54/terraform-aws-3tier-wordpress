# 🚀 AWS 3-Tier Highly Available WordPress Architecture

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)

## 📌 Project Overview
This project demonstrates a production-ready, **Highly Available 3-Tier Web Architecture** on AWS, fully automated with Terraform. It focuses on the **Security** and **Reliability** pillars of the AWS Well-Architected Framework by isolating layers into public and private subnets across multiple Availability Zones.

### 🏗️ Architecture Design
The architecture is designed to handle failure and secure sensitive data:
* **Public Tier:** Internet Gateway (IGW) and Application Load Balancer (ALB).
* **Application Tier:** EC2 instances in private subnets, utilizing a NAT Gateway for outbound updates.
* **Data Tier:** Amazon RDS (MySQL) and Amazon EFS (Elastic File System) for persistent, shared storage across instances.

(diagram soon)
---

## 🛠️ Infrastructure Components

### 🌐 Networking (VPC)
* **Multi-AZ:** Deployment across 2 Availability Zones for high availability.
* **Subnetting:** * 2 Public Subnets (ALB & NAT Gateway).
    * 2 Private Subnets (WordPress Application).
    * 2 Private Subnets (RDS Database).
* **Routing:** Custom Route Tables directing private traffic through a NAT Gateway and public traffic through the IGW.

### 🖥️ Compute & Load Balancing
* **ALB:** Distributes incoming HTTP traffic across healthy EC2 instances.
* **Auto Scaling:** Manages a fleet of EC2 instances to ensure the application remains online.
* **User Data:** Automated installation of Apache, PHP, and WordPress configuration.

### 💾 Storage & Database
* **Amazon RDS:** Managed MySQL instance for the WordPress database.
* **Amazon EFS:** Shared filesystem mounted to `/var/www/html` on all instances, ensuring media uploads and configs persist even if instances are replaced.

---

## 🚀 How to Deploy

### Prerequisites
1.  AWS CLI configured with appropriate credentials.
2.  Terraform (v1.0+) installed.

### Steps
1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/edeak54/terraform-aws-3tier-wordpress.git
    cd terraform-aws-3tier-wordpress
    ```
2.  **Initialize Terraform:**
    ```bash
    terraform init
    ```
3.  **Deploy Infrastructure:**
    ```bash
    terraform apply
    ```
    *Note: You will be prompted to enter a `db_password` for the RDS instance.*

---

## ✅ Proof of Concept & Validation

### 1. High Availability Proof
I performed a "Chaos Test" by terminating a running instance. The Auto Scaling Group automatically provisioned a replacement. Because of the **EFS mount**, the new instance instantly served the existing WordPress site content without manual intervention.

### 2. Infrastructure Status
* **Target Group Health:** All instances marked "Healthy" behind the ALB.
* **VPC Resource Map:** Verified visual routing logic from IGW to Private Subnets.

<img width="776" height="188" alt="healthy" src="https://github.com/user-attachments/assets/e3e59c4a-6ff3-41a4-b516-55f4b1077c7a" />
> <img width="811" height="332" alt="vpc_map" src="https://github.com/user-attachments/assets/66c2f357-6d6d-46bc-b3f3-a0f11fba0ae5" />
---

## 🛡️ Security Best Practices
* **Zero Public IPs:** EC2 instances are in private subnets with no direct internet access.
* **Security Group Chaining:** Rules are restricted so the DB only accepts traffic from the App Tier, and the App Tier only accepts traffic from the ALB.
* **Sensitive Variables:** Secrets are handled via Terraform variables and excluded from version control via `.gitignore`.

## 🧹 Cleanup
To avoid ongoing costs for the NAT Gateway and RDS, destroy all resources:
```bash
terraform destroy
