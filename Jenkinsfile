pipeline {
    agent any

    tools {
        jdk 'jdk17' // Make sure Jenkins has Java 17 installed and named 'jdk17'
    }

    environment {
        IMAGE_NAME = "static-site-nginx"
        DOCKER_TAG = "${BUILD_NUMBER}"
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10')) // Keep last 10 builds
        timestamps() // Add timestamps to console output
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Inject Build Info') {
            steps {
                sh '''
                # Replace placeholder {{BUILD_NUMBER}} in HTML with actual Jenkins build number
                sed -i "s/{{BUILD_NUMBER}}/${BUILD_NUMBER}/g" app/index.html
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${DOCKER_TAG}")
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                # Stop and remove old container if exists
                docker stop app || true
                docker rm app || true

                # Run new container with updated image
                docker run -d --name app -p 8090:80 ${IMAGE_NAME}:${DOCKER_TAG}
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                echo "Checking container health..."
                curl -f http://localhost:8090 || exit 1
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed. Check the console output for errors."
        }
    }
}
