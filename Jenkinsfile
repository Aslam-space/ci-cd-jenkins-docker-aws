pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        AWS_ACCOUNT_ID = "357225327957"
        ECR_REPO = "static-site"
        IMAGE_TAG = "${BUILD_NUMBER}"
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        IMAGE_NAME = "ci-cd-static:latest"
        CONTAINER_NAME = "ci-cd-container"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Generate Metadata & Cache-Bust') {
            steps {
                sh '''
                #!/bin/bash
                # Inject BUILD_NUMBER & short GIT_COMMIT into index.html
                sed -i "s/{{BUILD_NUMBER}}/${BUILD_NUMBER}/g" app/index.html
                GIT_SHORT=$(echo ${GIT_COMMIT} | cut -c1-7)
                sed -i "s/{{GIT_COMMIT}}/${GIT_SHORT}/g" app/index.html

                # Add cache-buster for images
                TIMESTAMP=$(date +%s)
                sed -i "s/{{CACHE_BUST}}/${TIMESTAMP}/g" app/index.html

                # Generate metadata.json for dynamic frontend display
                cat > app/metadata.json <<EOF
                {
                  "BUILD_NUMBER": "${BUILD_NUMBER}",
                  "GIT_COMMIT": "${GIT_SHORT}"
                }
                EOF
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME} app/"
            }
        }

        stage('Stop & Remove Old Container') {
            steps {
                sh '''
                # Stop & remove old container if it exists
                CONTAINER=$(docker ps -aq -f name=${CONTAINER_NAME})
                if [ ! -z "$CONTAINER" ]; then
                    docker rm -f $CONTAINER
                fi
                '''
            }
        }

        stage('Run New Container') {
            steps {
                sh "docker run -d --name ${CONTAINER_NAME} -p 8090:80 ${IMAGE_NAME}"
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

        stage('Push Image to ECR') {
            steps {
                sh '''
                docker tag ${IMAGE_NAME} ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}
                docker push ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}
                '''
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD pipeline complete. Container running and image pushed to ECR."
        }
        failure {
            echo "❌ Pipeline failed. Check logs."
        }
        always {
            sh 'docker image prune -af || true'
        }
    }
}
