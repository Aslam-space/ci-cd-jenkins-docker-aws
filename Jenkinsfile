pipeline {
    agent any

    environment {
        AWS_REGION      = "us-east-1"
        ECR_REPO        = "123456789012.dkr.ecr.us-east-1.amazonaws.com/static-site"
        IMAGE_TAG       = "${BUILD_NUMBER}"
        CONTAINER_NAME  = "nginx-app"
        HOST_PORT       = "8090"
    }

    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '15'))
    }

    stages {

        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Inject Build Metadata') {
            steps {
                sh '''
                  sed -i "s/{{BUILD_NUMBER}}/${BUILD_NUMBER}/g" app/index.html
                  sed -i "s/{{GIT_COMMIT}}/${GIT_COMMIT}/g" app/index.html
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                  docker build -t static-site:${IMAGE_TAG} .
                '''
            }
        }

        stage('Authenticate to AWS ECR') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                      aws ecr get-login-password --region ${AWS_REGION} \
                      | docker login --username AWS --password-stdin ${ECR_REPO}
                    '''
                }
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                  docker tag static-site:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
                  docker push ${ECR_REPO}:${IMAGE_TAG}
                '''
            }
        }

        stage('Deploy with Rollback Safety') {
            steps {
                sh '''
                  PREVIOUS_IMAGE=$(docker inspect ${CONTAINER_NAME} --format='{{.Config.Image}}' 2>/dev/null || true)

                  docker stop ${CONTAINER_NAME} || true
                  docker rm ${CONTAINER_NAME} || true

                  docker run -d \
                    --name ${CONTAINER_NAME} \
                    -p ${HOST_PORT}:80 \
                    ${ECR_REPO}:${IMAGE_TAG} || {

                      echo "Deployment failed. Rolling back..."
                      docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p ${HOST_PORT}:80 \
                        ${PREVIOUS_IMAGE}
                      exit 1
                  }
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                  sleep 5
                  curl -f http://localhost:${HOST_PORT} > /dev/null
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Production deployment successful"
        }
        failure {
            echo "❌ Deployment failed (rollback attempted)"
        }
        always {
            sh 'docker image prune -f || true'
        }
    }
}
