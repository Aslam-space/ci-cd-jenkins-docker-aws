pipeline {
    agent any

    environment {
        AWS_REGION     = 'us-east-1'
        AWS_ACCOUNT_ID = '123456789012'   // 🔴 replace with real account id
        ECR_REPO_NAME  = 'static-site'
        ECR_REGISTRY   = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

        IMAGE_TAG      = "${BUILD_NUMBER}"
        CONTAINER_NAME = 'nginx-app'
        HOST_PORT      = '8090'
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {

        /* =======================
           1️⃣ GITHUB CHECKOUT
           ======================= */
        stage('Checkout Source') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Aslam-space/ci-cd-jenkins-docker-aws.git',
                    credentialsId: 'github-credentials'
            }
        }

        /* =======================
           2️⃣ PRE-FLIGHT CHECKS
           ======================= */
        stage('Preflight Checks') {
            steps {
                sh '''
                  whoami
                  docker --version
                  aws --version
                '''
            }
        }

        /* =======================
           3️⃣ AWS CREDENTIAL TEST
           ======================= */
        stage('AWS Credential Smoke Test') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-prod-creds',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh '''
                      aws sts get-caller-identity
                    '''
                }
            }
        }

        /* =======================
           4️⃣ DOCKER CLEANUP
           ======================= */
        stage('Clean Docker') {
            steps {
                sh '''
                  docker container prune -f || true
                  docker image prune -af || true
                '''
            }
        }

        /* =======================
           5️⃣ BUILD IMAGE
           ======================= */
        stage('Build Docker Image') {
            steps {
                sh '''
                  docker build -t ${ECR_REPO_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        /* =======================
           6️⃣ LOGIN TO ECR
           ======================= */
        stage('Login to AWS ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-prod-creds',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh '''
                      aws ecr get-login-password --region ${AWS_REGION} \
                      | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    '''
                }
            }
        }

        /* =======================
           7️⃣ PUSH IMAGE
           ======================= */
        stage('Push Image to ECR') {
            steps {
                sh '''
                  docker tag ${ECR_REPO_NAME}:${IMAGE_TAG} ${ECR_REGISTRY}/${ECR_REPO_NAME}:${IMAGE_TAG}
                  docker push ${ECR_REGISTRY}/${ECR_REPO_NAME}:${IMAGE_TAG}
                '''
            }
        }

        /* =======================
           8️⃣ RUN CONTAINER
           ======================= */
        stage('Deploy Container') {
            steps {
                sh '''
                  docker stop ${CONTAINER_NAME} || true
                  docker rm ${CONTAINER_NAME} || true

                  docker run -d \
                    --name ${CONTAINER_NAME} \
                    -p ${HOST_PORT}:80 \
                    ${ECR_REGISTRY}/${ECR_REPO_NAME}:${IMAGE_TAG}
                '''
            }
        }

        /* =======================
           9️⃣ HEALTH CHECK
           ======================= */
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
            echo "✅ PIPELINE SUCCESS — GREEN BUILD"
        }
        failure {
            echo "❌ PIPELINE FAILED — CHECK LOGS"
        }
    }
}
