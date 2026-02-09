# CI/CD Jenkins + Docker + AWS Static Site Pipeline

**Repository:** `ci-cd-jenkins-docker-aws`  
**Role:** Full DevOps Pipeline Showcase  

---

## Project Overview

This project demonstrates a complete CI/CD pipeline for deploying a static website using Jenkins, Docker, and AWS, including monitoring and automated health checks.  

---

## Architecture
---

## Features

- Automated CI/CD: Push code → Jenkins builds → Docker container updates  
- Multi-stage Docker: Optimized image size, reproducible builds  
- Health Checks: Automatic container monitoring and restart if unhealthy  
- AWS ECR Integration: Container images stored securely in the cloud  
- Cloudflare Ready: Supports secure HTTPS deployment  
- Dynamic Metadata: Injects build number and Git commit hash for traceability  

---

## How to Run Locally

```bash
git clone https://github.com/Aslam-space/ci-cd-jenkins-docker-aws.git
cd ci-cd-jenkins-docker-aws
docker build -t ci-cd-static:latest -f Dockerfile.multi-stage app/
docker run -d --name ci-cd-container -p 8090:80 ci-cd-static:latest
./healthcheck.sh
