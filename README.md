# CI/CD Pipeline with Jenkins, Docker & AWS EC2

## Overview
This project demonstrates a production-style CI/CD pipeline that automatically builds and deploys a Dockerized Nginx application on AWS EC2 using Jenkins.

## Tech Stack
- Jenkins (Pipeline as Code)
- Docker
- Nginx
- AWS EC2
- GitHub

## Pipeline Flow
1. Jenkins checks out source code from GitHub
2. Injects build metadata (build number, git commit) into UI
3. Builds Docker image
4. Deploys container on EC2
5. Verifies deployment
6. Cleans up unused images

## Key Features
- Fully automated deployment
- Zero-downtime container replacement
- Build traceability via UI
- Production-ready Jenkinsfile

## How to Run
Trigger a Jenkins build. The application will be available on port 8090.
