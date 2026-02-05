pipeline {
    agent any

    environment {
        IMAGE_NAME = "static-site-nginx"
        CONTAINER_NAME = "nginx-app"
        HOST_PORT = "8090"
    }

    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '15'))
        disableConcurrentBuilds()
    }

    stages {

        stage('Checkout Source') {
            steps {
                echo "Checking out source code from Git..."
                checkout scm
            }
        }

        stage('Inject Build Metadata') {
            steps {
                echo "Injecting Jenkins metadata into UI..."
                sh '''
                  sed -i "s/{{BUILD_NUMBER}}/${BUILD_NUMBER}/g" app/index.html
                  sed -i "s/{{GIT_COMMIT}}/${GIT_COMMIT}/g" app/index.html
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh '''
                  docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                  docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${IMAGE_NAME}:latest
                '''
            }
        }

        stage('Deploy Container') {
            steps {
                echo "Deploying container on EC2..."
                sh '''
                  docker stop ${CONTAINER_NAME} || true
                  docker rm ${CONTAINER_NAME} || true

                  docker run -d \
                    --name ${CONTAINER_NAME} \
                    -p ${HOST_PORT}:80 \
                    ${IMAGE_NAME}:latest
                '''
            }
        }

        stage('Post-Deploy Verification') {
            steps {
                echo "Verifying deployment..."
                sh '''
                  sleep 5
                  curl -f http://localhost:${HOST_PORT} | grep "CI/CD Production Demo"
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful"
        }
        failure {
            echo "❌ Deployment failed"
        }
        always {
            sh 'docker image prune -f || true'
        }
    }
}
