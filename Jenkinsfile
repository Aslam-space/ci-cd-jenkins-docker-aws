pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        AWS_ACCOUNT_ID = "357225327957"
        ECR_REPO = "static-site"
        IMAGE_TAG = "${BUILD_NUMBER}"
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Inject Build Metadata') {
            steps {
                sh '''
                sed -i "s/{{BUILD_NUMBER}}/${BUILD_NUMBER}/g" app/index.html
                sed -i "s/{{GIT_COMMIT}}/${GIT_COMMIT:0:7}/g" app/index.html
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t ${ECR_REPO}:${IMAGE_TAG} app/
                '''
            }
        }

        stage('Login to ECR') {
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
                docker tag ${ECR_REPO}:${IMAGE_TAG} \
                ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}

                docker push ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Image pushed successfully to ECR"
        }
        failure {
            echo "❌ Pipeline failed"
        }
        always {
            sh 'docker image prune -af || true'
        }
    }
}
