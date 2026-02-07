pipeline {
    agent any

    environment {
        AWS_REGION     = 'us-east-1'
        AWS_ACCOUNT_ID = '123456789012'
        ECR_REPO_NAME  = 'static-site'
        ECR_REGISTRY   = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

        IMAGE_TAG      = "${BUILD_NUMBER}-${GIT_COMMIT.take(7)}"
        CONTAINER_NAME = 'nginx-app'
        HOST_PORT      = '8090'
        DOCKER_BUILDKIT = '1'
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
                  sed -i "s/{{GIT_COMMIT}}/${GIT_COMMIT.take(7)}/g" app/index.html
                '''
            }
        }

        stage('Preflight Checks') {
            steps {
                sh '''
                  command -v docker >/dev/null || { echo "Docker missing"; exit 1; }
                  command -v aws >/dev/null || { echo "AWS CLI missing"; exit 1; }
                '''
            }
        }

        stage('AWS Cred Smoke Test') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-prod-creds'
                ]]) {
                    sh 'aws sts get-caller-identity'
                }
            }
        }

        stage('Clean Docker Environment') {
            steps {
                sh '''
                  echo "🧹 Cleaning old Docker containers and images..."
                  docker container prune -f || true
                  docker image prune -af || true
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    retry(2) {
                        sh '''
                          echo "🚀 Building Docker image..."
                          # Copy only the app folder to reduce context size
                          docker build --progress=plain -t ${ECR_REPO_NAME}:${IMAGE_TAG} app/
                        '''
                    }
                }
            }
        }

        stage('Authenticate to AWS ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-prod-creds'
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
                script {
                    retry(2) {
                        sh '''
                          docker tag ${ECR_REPO_NAME}:${IMAGE_TAG} ${ECR_REGISTRY}/${ECR_REPO_NAME}:${IMAGE_TAG}
                          docker tag ${ECR_REPO_NAME}:${IMAGE_TAG} ${ECR_REGISTRY}/${ECR_REPO_NAME}:latest

                          docker push ${ECR_REGISTRY}/${ECR_REPO_NAME}:${IMAGE_TAG}
                          docker push ${ECR_REGISTRY}/${ECR_REPO_NAME}:latest
                        '''
                    }
                }
            }
        }

        stage('Deploy with Rollback Safety') {
            steps {
                sh '''
                  PREVIOUS_IMAGE=$(docker inspect ${CONTAINER_NAME} \
                    --format='{{.Config.Image}}' 2>/dev/null || echo "")

                  docker stop ${CONTAINER_NAME} || true
                  docker rm ${CONTAINER_NAME} || true

                  docker run -d \
                    --name ${CONTAINER_NAME} \
                    -p ${HOST_PORT}:80 \
                    ${ECR_REGISTRY}/${ECR_REPO_NAME}:${IMAGE_TAG} || {

                      echo "❌ Deployment failed"

                      if [ -n "$PREVIOUS_IMAGE" ]; then
                        echo "↩ Rolling back to $PREVIOUS_IMAGE"
                        docker run -d \
                          --name ${CONTAINER_NAME} \
                          -p ${HOST_PORT}:80 \
                          $PREVIOUS_IMAGE
                      else
                        echo "⚠ No previous image found"
                      fi
                      exit 1
                  }
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                  sleep 5
                  curl -f http://localhost:${HOST_PORT} || exit 1
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Production deployment successful"
        }
        failure {
            echo "❌ Deployment failed"
        }
        always {
            sh '''
              echo "🧹 Cleaning up Docker images..."
              docker image prune -af || true
            '''
        }
    }
}
