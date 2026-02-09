pipeline {
    agent any

    environment {
        AWS_REGION     = "us-east-1"
        AWS_ACCOUNT_ID = "357225327957"
        ECR_REPO       = "static-site"
        IMAGE_TAG      = "${BUILD_NUMBER}"
        ECR_REGISTRY   = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        IMAGE_NAME     = "ci-cd-static:latest"
        CONTAINER_NAME = "ci-cd-container"
        APP_DIR        = "app"
    }

    stages {

        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Generate Metadata & Cache-Bust') {
            steps {
                sh '''
                #!/bin/bash
                sed -i "s/{{BUILD_NUMBER}}/${BUILD_NUMBER}/g" ${APP_DIR}/index.html
                GIT_SHORT=$(git rev-parse --short HEAD)
                sed -i "s/{{GIT_COMMIT}}/${GIT_SHORT}/g" ${APP_DIR}/index.html
                TIMESTAMP=$(date +%s)
                sed -i "s/{{CACHE_BUST}}/${TIMESTAMP}/g" ${APP_DIR}/index.html
                cat > ${APP_DIR}/metadata.json <<EOF
                {
                  "BUILD_NUMBER": "${BUILD_NUMBER}",
                  "GIT_COMMIT": "${GIT_SHORT}"
                }
                EOF
                '''
            }
        }

        stage('Build Multi-Stage Docker Image') {
            steps {
                sh '''
                docker build -t ${IMAGE_NAME} -f Dockerfile.multi-stage ${APP_DIR}/
                '''
            }
        }

        stage('Stop & Remove Old Container') {
            steps {
                sh '''
                OLD_CONTAINER=$(docker ps -aq -f name=${CONTAINER_NAME})
                if [ ! -z "$OLD_CONTAINER" ]; then
                    docker rm -f $OLD_CONTAINER
                fi
                '''
            }
        }

        stage('Run New Container') {
            steps {
                sh '''
                docker run -d \
                  --name ${CONTAINER_NAME} \
                  -p 8090:80 \
                  ${IMAGE_NAME}
                '''
            }
        }

        stage('Verify Container Health') {
            steps {
                sh '''
                sleep 5
                STATUS=$(docker inspect --format='{{.State.Health.Status}}' ${CONTAINER_NAME} 2>/dev/null || echo "unknown")
                if [ "$STATUS" != "healthy" ]; then
                    echo "⚠️ Container unhealthy, restarting..."
                    docker restart ${CONTAINER_NAME}
                    sleep 5
                    STATUS=$(docker inspect --format='{{.State.Health.Status}}' ${CONTAINER_NAME} 2>/dev/null || echo "unknown")
                    if [ "$STATUS" != "healthy" ]; then
                        echo "❌ Container failed health check!"
                        exit 1
                    fi
                else
                    echo "✅ Container is healthy."
                fi
                '''
            }
        }

        stage('Login to AWS ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {
                    sh '''
                    aws ecr get-login-password --region ${AWS_REGION} \
                      | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    '''
                }
            }
        }

        stage('Tag & Push Image to ECR') {
            steps {
                sh '''
                docker tag ${IMAGE_NAME} ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}
                docker push ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}
                '''
            }
        }

        stage('Clean Up Local Docker Images') {
            steps { sh 'docker image prune -af || true' }
        }

    }

    post {
        success {
            echo "✅ Pipeline complete: container running + image pushed."
        }
        failure {
            echo "❌ Pipeline failed! Check logs."
        }
        always {
            sh 'docker image prune -af || true'
        }
    }
}
