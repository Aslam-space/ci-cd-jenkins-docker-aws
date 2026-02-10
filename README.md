# CI/CD Pipeline for Production-Grade Static Website Deployment  
### Jenkins • Docker • AWS EC2 • AWS ECR • Cloudflare

[![CI/CD](https://img.shields.io/badge/CI%2FCD-Jenkins-success)](#)
[![Docker](https://img.shields.io/badge/Containerized-Docker-blue)](#)
[![AWS](https://img.shields.io/badge/Cloud-AWS-orange)](#)
[![Cloudflare](https://img.shields.io/badge/Security-Cloudflare-yellow)](#)

**Repository Name:** `ci-cd-jenkins-docker-aws`  
**Domain:** DevOps | CI/CD | Cloud Infrastructure | Automation  
**Project Type:** Production-Oriented CI/CD Pipeline Implementation

---

## 1. Executive Summary

This project demonstrates a **production-grade CI/CD pipeline** for deploying and operating a static web application using **Jenkins, Docker, AWS EC2, AWS ECR, and Cloudflare**.

The pipeline is designed with **automation, reliability, observability, and operational best practices** in mind. It reflects real-world DevOps workflows used in modern production environments rather than a simple demo deployment.

Key focus areas include:
- Automated build and deployment
- Immutable container-based releases
- Health verification and failure handling
- Secure cloud exposure using Cloudflare
- Traceability across builds and deployments

---

## 2. High-Level Architecture
Developer Push (GitHub) │ │ Webhook Event ▼ Jenkins CI/CD Pipeline ├─ Source Code Checkout ├─ Build Metadata Injection ├─ Multi-Stage Docker Image Build ├─ Stop & Replace Running Container ├─ Application Health Validation ├─ Image Versioning & Tagging └─ Push Image to AWS ECR │ ▼ AWS EC2 (Docker Runtime) └─ Nginx Container Serving Static Website │ ▼ Cloudflare Tunnel / Proxy └─ HTTPS, DNS, and Security Layer

---

## 3. CI/CD Pipeline Design (Jenkins)

The Jenkins pipeline is defined declaratively using a `Jenkinsfile` and is triggered automatically via **GitHub Webhooks**.

### Pipeline Stages

1. **Source Checkout**
   - Pulls the latest code from the GitHub repository
   - Ensures every build is traceable to a specific commit

2. **Metadata Injection**
   - Injects runtime metadata into the application:
     - Jenkins build number
     - Git commit hash
   - Enables build traceability and deployment auditing

3. **Multi-Stage Docker Build**
   - Uses a multi-stage Dockerfile to:
     - Reduce final image size
     - Separate build-time and runtime concerns
     - Improve performance and security

4. **Container Replacement Strategy**
   - Stops and removes any previously running container
   - Deploys a new container using the latest image
   - Ensures clean, immutable deployments

5. **Health Verification**
   - Performs automated container health checks
   - Detects unhealthy states
   - Automatically restarts the container if required
   - Fails the pipeline if the application does not stabilize

6. **Image Versioning and Registry Push**
   - Tags Docker images using Jenkins build numbers
   - Pushes versioned images to AWS ECR
   - Enables rollback and artifact tracking

7. **Automated Cleanup**
   - Removes unused Docker images
   - Prevents disk exhaustion on the EC2 host

---

## 4. Containerization Strategy (Docker)

- **Base Image:** `nginx:alpine`
- **Purpose:** Lightweight, secure, production-ready static content hosting
- **Configuration:**
  - Custom Nginx configuration
  - Static assets copied during build
  - Health check endpoint exposed

### Benefits
- Fast startup time
- Predictable runtime behavior
- Environment parity between builds and deployments

---

## 5. AWS Infrastructure Usage

### AWS EC2
- Acts as the Docker runtime host
- Runs Jenkins agent and application containers
- Instance is started on-demand to optimize cost

### AWS ECR
- Stores versioned Docker images
- Enables secure, centralized artifact management
- Aligns with enterprise container workflows

---

## 6. Cloudflare Integration

Cloudflare is used as a **production security and networking layer**:

- Provides HTTPS termination
- Protects the application IP
- Enables DNS-based routing
- Supports Cloudflare Tunnel for secure exposure without static IP dependency

This approach reflects real-world practices where applications are not directly exposed to the public internet.

---

## 7. Application Health & Reliability

Health checks are treated as a **first-class concern**, not an afterthought.

- Automated container health verification
- Pipeline-level failure detection
- Restart logic for transient failures
- Prevents broken deployments from being considered successful

This mirrors production SRE and DevOps reliability patterns.

---

## 8. Automation Philosophy

This project avoids manual intervention wherever possible:

- No manual deployments
- No manual container restarts
- No manual image management
- No manual environment drift handling

Every deployment follows the same automated, repeatable process.

---

## 9. Application Preview

> The EC2 instance is started manually when required.

**Access Pattern:**
### Website Screenshot

![Website Preview](my%20site-demo.jpeg)

### Detailed Pipeline Walkthrough

[CI/CD Pipeline Demo (PDF)](CI_CD%20Pipeline%20Demo.pdf)

## 10. Repository Structure
---

## 11. Skills Demonstrated

- CI/CD pipeline engineering using Jenkins  
- Production-grade Docker containerization  
- AWS EC2 and ECR integration  
- Secure application exposure using Cloudflare  
- Automated health checks and failure handling  
- Infrastructure-aware deployment automation  
- Build traceability and artifact versioning  

---

## 12. Use Case

This project is intended as:
- A DevOps internship portfolio project
- A CI/CD reference implementation
- A demonstration of production-focused DevOps practices

---

## 13. Status

Active learning and demonstration repository.
