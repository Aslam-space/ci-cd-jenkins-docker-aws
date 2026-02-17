# CI/CD Pipeline for Static Website Deployment  
### Jenkins • Docker • AWS EC2 • AWS ECR • Cloudflare  

🔗 **Live Demo (Render):**  
https://ci-cd-jenkins-docker-aws.onrender.com  

[![CI/CD](https://img.shields.io/badge/CI%2FCD-Jenkins-success)](#)
[![Docker](https://img.shields.io/badge/Containerized-Docker-blue)](#)
[![AWS](https://img.shields.io/badge/Cloud-AWS-orange)](#)
[![Cloudflare](https://img.shields.io/badge/Security-Cloudflare-yellow)](#)

**Repository:** `ci-cd-jenkins-docker-aws`  
**Domain:** DevOps | CI/CD | Cloud Infrastructure | Automation  

---

## 1. Overview

This project implements an automated CI/CD pipeline for deploying a containerized static web application using Jenkins, Docker, AWS EC2, AWS ECR, and Cloudflare.

It demonstrates automated builds, immutable container deployments, image versioning, health validation, and secure cloud exposure.

---

## 2. Architecture
GitHub Push ↓ Jenkins Pipeline ├─ Source Checkout ├─ Metadata Injection ├─ Multi-Stage Docker Build ├─ Container Replacement ├─ Health Verification └─ Push Image to AWS ECR ↓ AWS EC2 (Docker Runtime) ↓ Cloudflare (DNS + HTTPS Proxy)
---

## 3. CI/CD Pipeline Design

The pipeline is defined using a declarative `Jenkinsfile` and triggered via GitHub webhooks.

### Pipeline Stages

1. **Source Checkout**  
   Pulls the latest commit from GitHub.

2. **Metadata Injection**  
   Injects build number and commit hash for traceability.

3. **Multi-Stage Docker Build**  
   Builds a lightweight production image using `nginx:alpine`.

4. **Container Replacement Strategy**  
   Stops and replaces the running container with the new image.

5. **Health Verification**  
   Validates container health before marking deployment successful.

6. **Image Versioning & Push**  
   Tags images using build numbers and pushes them to AWS ECR.

7. **Cleanup**  
   Removes unused Docker images to prevent disk exhaustion.

---

## 4. Containerization Strategy

- **Base Image:** `nginx:alpine`
- Static assets copied during build
- Custom Nginx configuration
- Health check integration

This ensures predictable runtime behavior and lightweight deployments.

---

## 5. AWS Infrastructure

### AWS EC2
- Hosts Jenkins and Docker runtime
- Runs the application container

### AWS ECR
- Stores versioned Docker images
- Enables centralized artifact management and rollback capability

---

## 6. Cloudflare Integration

Cloudflare provides:

- HTTPS termination
- DNS routing
- Proxy-based security layer
- IP protection for the EC2 instance

---

## 7. Application Preview

### Website Screenshot

![Website Preview](my%20site-demo.jpeg)

### Detailed Pipeline Walkthrough

[CI/CD Pipeline Demo (PDF)](CI_CD%20Pipeline%20Demo.pdf)

---

## 8. Skills Demonstrated

- CI/CD pipeline engineering with Jenkins  
- Docker containerization and image optimization  
- AWS EC2 and ECR integration  
- Secure deployment using Cloudflare  
- Automated health validation  
- Image versioning and artifact management  

---

## 9. Use Case

This repository serves as:

- A DevOps internship portfolio project  
- A CI/CD reference implementation  
- A practical demonstration of automated container deployment  

---

## 10. Status

Active demonstration and learning repository.
