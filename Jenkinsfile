pipeline {
    agent any

    environment {
        APP_NAME = "static-site-nginx"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        IMAGE_NAME = "${APP_NAME}:${IMAGE_TAG}"
        CONTAINER_NAME = "nginx-site"
        APP_PORT = "8090"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'git@github.com:Aslam-space/ci-cd-jenkins-docker-aws.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                echo "Building Docker image ${IMAGE_NAME}"
                docker build -t ${IMAGE_NAME} ./app
                '''
            }
        }

        stage('Stop Old Container (if exists)') {
            steps {
                sh '''
                if docker ps -a --format '{{.Names}}' | grep -w ${CONTAINER_NAME}; then
                    echo "Stopping old container"
                    docker stop ${CONTAINER_NAME}
                    docker rm ${CONTAINER_NAME}
                else
                    echo "No existing container found"
                fi
                '''
            }
        }

        stage('Run New Container') {
            steps {
                sh '''
                echo "Starting new container"
                docker run -d \
                  --name ${CONTAINER_NAME} \
                  -p ${APP_PORT}:80 \
                  ${IMAGE_NAME}
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                echo "Performing health check..."
                sleep 5
                curl -f http://localhost:${APP_PORT} || exit 1
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful — Build #${BUILD_NUMBER}"
        }
        failure {
            echo "❌ Deployment failed — check
