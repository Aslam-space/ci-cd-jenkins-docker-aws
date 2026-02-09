# CI/CD Pipeline: Jenkins + Docker + AWS

This repository demonstrates a **production-grade CI/CD pipeline** for a Dockerized static website, integrating **Jenkins, Docker, AWS, and Cloudflare** to simulate real-world DevOps workflows. The project is designed for **on-demand live demos** and showcases hands-on end-to-end pipeline automation.

---

## Project Overview

- **Source Control:** GitHub repository triggers Jenkins pipeline on every push.  
- **Continuous Integration:** Jenkins declarative pipeline automates code checkout, metadata injection, Docker build, container replacement, and image push to AWS ECR.  
- **Continuous Deployment:** Multi-stage Docker builds optimize image size and ensure smooth container deployment.  
- **Secure Public Access:** Cloudflare Tunnel exposes the running application via HTTPS during live demos.  
- **Monitoring & Health Checks:** Custom healthcheck script ensures uptime and reliability.  
- **Cost-Aware:** EC2 instance and services run on-demand, minimizing cloud expenses.

---

## Key Features

- Automated **CI/CD pipeline** triggered by GitHub push  
- **Dynamic metadata injection**: BUILD_NUMBER, GIT_COMMIT, cache-busting  
- **Multi-stage Docker builds** for optimized, production-ready images  
- **Zero-downtime container replacement**  
- **AWS ECR** integration for versioned container images  
- **Cloudflare Tunnel** for secure, temporary public access  
- **Health checks** for container monitoring  
- Cost-efficient design for **on-demand live demo**

---

## How the Demo Works

1. Start the EC2 instance manually.  
2. Launch Jenkins service.  
3. Deploy the Docker container via Jenkins pipeline.  
4. Run Cloudflare Tunnel to generate a temporary public URL.  
5. Push a GitHub commit → Jenkins automatically rebuilds and redeploys.  
6. Health checks confirm the container is running.

---

## Tech Stack

- **CI/CD:** Jenkins (Declarative Pipeline)  
- **Containerization:** Docker (Multi-stage builds)  
- **Cloud Infrastructure:** AWS EC2, AWS ECR  
- **Secure Exposure:** Cloudflare Tunnel  
- **Scripting:** Bash, Linux commands  
- **Monitoring:** Health check scripts inside containers

---

## Skills Demonstrated

- End-to-end **CI/CD implementation**  
- Docker multi-stage builds and container lifecycle management  
- AWS deployment and ECR versioning  
- Automated deployment with secure public exposure  
- Cost-aware, on-demand cloud infrastructure management  
- Live, hands-on DevOps workflow demonstration
