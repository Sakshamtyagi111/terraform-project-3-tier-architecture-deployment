 terraform-project-3-tier-architecture-deployment

# AWS 3-Tier Production-Grade Infrastructure with Terraform

## 🚀 Project Overview
This project demonstrates a fully automated, high-availability 3-tier web architecture deployed on AWS using Terraform. It features a public-facing load balancer, a private application tier, and a secure, managed database layer.

### 👤 Featured Application: Saksham Tyagi's Guestbook
The deployment includes a full-stack PHP application that serves as a **Proof of Concept**. Users can submit their details through a web form, which are then stored and retrieved from the private RDS MySQL instance, proving end-to-end connectivity and security group integrity.

---

## 🏗️ Architecture
The infrastructure is distributed across two Availability Zones (us-east-1a and us-east-1b) to ensure maximum uptime and fault tolerance.


* **Tier 1: Web Tier (Public)**
    * Application Load Balancer (ALB) receiving external traffic on Port 80.
    * Public subnets with an Internet Gateway for external reachability.
* **Tier 2: Application Tier (Private)**
    * EC2 instances (t3.micro) running Amazon Linux 2023.
    * Isolated in private subnets; reachable only from the ALB.
    * NAT Gateway integration for secure outbound updates.
* **Tier 3: Database Tier (Private)**
    * Managed Amazon RDS MySQL instance (db.t3.micro).
    * Deployed in Multi-AZ mode for high availability.
    * Strictly isolated; reachable only from the Application Tier on Port 3306.

---

## 🛠️ Technology Stack
* **IaC:** Terraform
* **Cloud:** AWS (VPC, ALB, EC2, RDS, S3, DynamoDB)
* **Backend:** PHP, Apache (httpd)
* **Database:** MySQL
* **State Management:** S3 (Storage) and DynamoDB (State Locking)

---

## 🔒 Security & Automation
- **Security Group Chaining:** Implemented a "least privilege" access model across all tiers.
- **Remote Backend:** Infrastructure state is managed remotely in S3 with versioning enabled.
- **State Locking:** DynamoDB prevents concurrent execution and state corruption.
- **Automated Bootstrap:** `user_data` scripts handle the automatic installation of the LAMP stack and application logic.

---

## 🚀 Deployment Instructions

1. **Prerequisites:**
   - AWS CLI configured.
   - S3 Bucket and DynamoDB table created for the Terraform backend.

