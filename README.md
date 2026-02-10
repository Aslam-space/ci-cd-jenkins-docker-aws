# CI/CD Jenkins + Docker + AWS Static Site Pipeline

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)](#)
[![Docker](https://img.shields.io/badge/docker-ready-blue)](#)
[![AWS](https://img.shields.io/badge/AWS-deployed-orange)](#)

**Repository:** `ci-cd-jenkins-docker-aws`  
**Purpose:** End-to-End DevOps CI/CD Pipeline Showcase (Recruiter-Ready)

---

## 🚀 Project Overview

This project demonstrates a **complete production-style CI/CD pipeline** for deploying a static website using **GitHub, Jenkins, Docker, and AWS EC2**, with container health checks and automated redeployment.

Every code change triggers a pipeline that:
- Builds a Docker image
- Deploys a container on EC2
- Verifies container health
- Pushes the image to AWS ECR

This repo is designed to **prove real DevOps hands-on skills**, not just theory.

---

## ✨ Key Features

- Automated CI/CD using **GitHub Webhooks + Jenkins**
- **Multi-stage Docker build** for optimized images
- **Zero-downtime container replacement**
- Automatic **container health verification**
- **AWS ECR image push**
- Metadata injection (`BUILD_NUMBER`, `GIT_COMMIT`)
- Automatic Docker cleanup to save disk space
- Production-style Jenkinsfile (Declarative Pipeline)

------

## 🖥 Live Demo / Preview

> ⚠️ EC2 instance is started **on-demand** to reduce cost.

**Example URL:**

## 🛠 Tools & Technologies

| Tool | Purpose |
|----|----|
| GitHub | Source control & webhook trigger |
| Jenkins | CI/CD automation |
| Docker | Containerization |
| AWS EC2 | Deployment host |
| AWS ECR | Docker image registry |
| Nginx | Static website hosting |
| Bash | Automation & health checks |

---

## 🏗 CI/CD Architecture Flow
### 📸 Website Preview

![CI/CD Static Site Preview](my%20site-demo.jpeg)

### 📄 Full Pipeline Walkthrough (PDF)

[View Full CI/CD Pipeline Demo](CI_CD%20Pipeline%20Demo.pdf)

---

## 📁 Repository Structure
---

## ▶️ Run Locally (Optional)

```bash
git clone https://github.com/Aslam-space/ci-cd-jenkins-docker-aws.git
cd ci-cd-jenkins-docker-aws

docker build -t ci-cd-static:latest -f Dockerfile.multi-stage app/
docker run -d --name ci-cd-container -p 8090:80 ci-cd-static:latest
