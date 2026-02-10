# CI/CD Jenkins + Docker + AWS Static Site Pipeline

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)](#)
[![Docker](https://img.shields.io/badge/docker-ready-blue)](#)
[![AWS](https://img.shields.io/badge/AWS-deployed-orange)](#)

**Repository:** `ci-cd-jenkins-docker-aws`  
**Category:** DevOps / CI-CD / Cloud Automation

---

## Project Overview

This repository contains an end-to-end **CI/CD pipeline implementation** for deploying a static website using **Jenkins, Docker, and AWS EC2**, with container health verification and automated redeployment.

The pipeline is triggered by GitHub webhooks and performs automated build, deployment, validation, and image publishing to AWS ECR.

---

## Features

- Automated CI/CD using GitHub Webhooks and Jenkins  
- Multi-stage Docker builds for optimized images  
- Automated container replacement on deployment  
- Container health verification and restart handling  
- Docker image publishing to AWS ECR  
- Build metadata injection (Build Number, Git Commit)  
- Automated Docker image cleanup  

---

## Tools & Technologies

| Tool | Usage |
|----|----|
| GitHub | Source control and webhook trigger |
| Jenkins | CI/CD pipeline automation |
| Docker | Containerization |
| AWS EC2 | Deployment host |
| AWS ECR | Docker image registry |
| Nginx | Static content hosting |
| Bash | Automation and health checks |

------

## Application Preview

> The EC2 instance is started on demand.

**Application URL format:**
### Website Screenshot

![Static Site Preview](my%20site-demo.jpeg)

### Detailed Pipeline Walkthrough (PDF)

[View CI/CD Pipeline Demo](CI_CD%20Pipeline%20Demo.pdf)

---

## Repository Structure
---

## Local Execution (Optional)

```bash
git clone https://github.com/Aslam-space/ci-cd-jenkins-docker-aws.git
cd ci-cd-jenkins-docker-aws

docker build -t ci-cd-static:latest -f Dockerfile.multi-stage app/
docker run -d --name ci-cd-container -p 8090:80 ci-cd-static:latest

## CI/CD Architecture
