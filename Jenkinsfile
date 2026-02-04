pipeline {
    agent any

    environment {
        IMAGE_NAME = "static-site-nginx"
        DOCKER_TAG = "${BUILD_NUMBER}"
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10')) // Keep last 10 builds
        timestamps() // Console timestamps
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out code..."
                checkout scm
            }
        }

        stage('Inject Build Info') {
            steps {
                echo "Injecting Jenkins build number into index.html..."
                sh '''
                # Replace placeholder {{BUILD_NUMBER}} in HTML with actual Jenkins build number
                sed -i "s/{{BUILD_NUMBER}}/${BUILD_NUMBER}/g" app/index.html
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                script {
                    docker.build("${IMAGE_NAME}:${DOCKER_TAG}")
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                echo "Stopping old container if exists..."
                sh '''
                docker stop app || true
                docker rm app || true
                echo "Running new container..."
                docker run -d --name app -p 8090:80 ${IMAGE_NAME}:${DOCKER_TAG}
                '''
            }
        }

        stage('Health Check') {
            steps {
                echo "Checking container health..."
                sh 'curl -f http://localhost:8090 || exit 1'
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully! Visit http://<EC2_PUBLIC_IP>:8090 to see the page."
        }
        failure {
            echo "❌ Pipeline failed. Check console output for details."
        }
    }
}
