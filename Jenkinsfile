pipeline {
    agent any

    environment {
        AWS_REGION      = 'us-east-1'
        AWS_ACCOUNT_ID  = '123456789012'
        ECR_REPO_NAME   = 'static-site'
        ECR_REGISTRY    = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

        IMAGE_TAG       = "${BUILD_NUMBER}"
        CONTAINER_NAME  = 'nginx-app'
        HOST_PORT       = '8090'
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

        /* 🔧 FIXED STAGE — THIS WAS YOUR FAILURE */
        stage('Inject Build Metadata') {
            steps {
                script {
                    def shortCommit = env.GIT_COMMIT.take(7)
                    sh """
                      sed -i 's/{{BUILD_NUMBER}}/${env.BUILD_NUMBER}/g' app/index.html
                      sed -i 's/{{GIT_COMMIT}}/${shortCommit}/g' app/index.html
                    """
                }
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
                  docker container prune -f || true
                  docker image prune -af || true
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                retry(2) {
                    sh '''
                      docker build -t ${ECR_REPO_NAME}:${IMAGE_TAG} app/
                    '''
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
                retry(2) {
                    sh '''
                      docker tag ${ECR_REPO_NAME}:${IMAGE_TAG} ${ECR_REGISTRY}/${ECR_REPO_NAME}:${IMAGE_TAG}
                      docker push ${ECR_REGISTRY}/${ECR_REPO_NAME}:${IMAGE_TAG}
                    '''
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

                      if [ -n "$PREVIOUS_IMAGE" ]; then
                        docker run -d \
                          --name ${CONTAINER_NAME} \
                          -p ${HOST_PORT}:80 \
                          $PREVIOUS_IMAGE
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
                  curl -f http://localhost:${HOST_PORT}
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
            sh 'docker image prune -af || true'
        }
    }
}
