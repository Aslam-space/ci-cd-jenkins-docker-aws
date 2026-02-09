# CI/CD Jenkins + Docker + AWS Static Site Pipeline

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)](#)
[![Docker Image](https://img.shields.io/badge/docker-ready-blue)](#)
[![AWS](https://img.shields.io/badge/AWS-deployed-orange)](#)

**Repository:** `ci-cd-jenkins-docker-aws`  
**Role:** Full DevOps Pipeline Showcase for Static Website Deployment  

---

## ✨ Features

- **Automated CI/CD:** Code pushes trigger Jenkins builds automatically  
- **Multi-Stage Docker:** Optimized container images for faster deployment  
- **Container Health Checks:** Automatic monitoring and restart if unhealthy  
- **AWS ECR Integration:** Push Docker images to AWS Elastic Container Registry  
- **Cloudflare Ready:** Supports secure HTTPS deployment via Cloudflare  
- **Dynamic Metadata Injection:** Injects BUILD_NUMBER and GIT_COMMIT for traceability  
- **Resource Cleanup:** Old Docker images removed automatically to save space  

---

## 🛠 Tools & Technologies

| Tool / Technology | Role |
|------------------|------|
| Jenkins           | CI/CD Automation |
| Docker            | Containerization |
| AWS ECR           | Container Registry |
| EC2               | Deployment Host |
| Bash              | Scripts & Health Checks |
| GitHub            | Source Code & Webhook Trigger |
| Cloudflare        | HTTPS / Secure Hosting |

---

## 🎯 Key Learning Outcomes

- Build **robust, production-ready pipelines**  
- Gain hands-on experience with **multi-stage Docker builds**  
- Automate deployment and monitoring for **24/7 uptime**  
- Learn integration between **GitHub, Jenkins, Docker, and AWS**  
- Troubleshoot pipeline failures and implement **health verification scripts**  
- Prepare a professional **DevOps project showcase** for recruiters  

---

## 🖥 Live Demo / Preview

> **Note:** Instance runs on-demand. EC2 must be started for the live site.  

Example URL (starts manually on-demand):  
`http://your-ec2-public-ip:8090`  

![Website Preview](docs/preview.jpeg)

📄 [Full Website Preview PDF](docs/preview.pdf)

---

## 🚀 Project Overview

This project demonstrates a **complete end-to-end CI/CD pipeline** for deploying a static website using **Jenkins, Docker, and AWS**, with monitoring and automated health checks.  

The goal is to showcase the **full DevOps lifecycle**:
- Code push → Automated build → Containerized deployment → Health monitoring → Cloud hosting  

This pipeline ensures that every change in the repository is automatically deployed to the live environment with minimal manual intervention.

---

## 📁 How to Run Locally

```bash
# Clone repository
git clone https://github.com/Aslam-space/ci-cd-jenkins-docker-aws.git
cd ci-cd-jenkins-docker-aws

# Build Docker image
docker build -t ci-cd-static:latest -f Dockerfile.multi-stage app/

# Run Docker container
docker run -d --name ci-cd-container -p 8090:80 ci-cd-static:latest

# Verify container health
./healthcheck.sh
