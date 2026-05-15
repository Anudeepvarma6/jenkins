pipeline {
    agent any

    tools {
        jdk 'jdk21'
        maven 'maven3'
    }

    environment {
        IMAGE_NAME = "366476834058.dkr.ecr.ap-south-1.amazonaws.com/java-standalone"
        AWS_REGION = "ap-south-1"
    }

    stages {
        stage('Git Checkout') {
            steps {
                git 'https://github.com/Anudeepvarma6/jenkins.git'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage('Build Application') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t java-app .'
            }
        }

        stage('Docker Push to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin 366476834058.dkr.ecr.ap-south-1.amazonaws.com

                docker tag java-app:latest $IMAGE_NAME:latest

                docker push $IMAGE_NAME:latest
                '''
            }
        }

        stage('Deploy to Dev') {
            steps {
                sh '''
                docker stop java-dev || true
                docker rm java-dev || true

                docker run -d \
                --name java-dev \
                -p 8081:5000 \
                $IMAGE_NAME:latest
                '''
            }
        }

        stage('Approval for Stage') {
            steps {
                input message: 'Approve deployment to STAGE environment?', ok: 'Deploy'
            }
        }

        stage('Deploy to Stage') {
            steps {
                sh '''
                docker stop java-stage || true
                docker rm java-stage || true

                docker run -d \
                --name java-stage \
                -p 8082:5000 \
                $IMAGE_NAME:latest
                '''
            }
        }

        stage('Approval for Prod') {
            steps {
                input message: 'Approve deployment to PRODUCTION environment?', ok: 'Deploy'
            }
        }

        stage('Deploy to Prod') {
            steps {
                sh '''
                docker stop java-prod || true
                docker rm java-prod || true

                docker run -d \
                --name java-prod \
                -p 8083:5000 \
                $IMAGE_NAME:latest
                '''
            }
        }
    }
}
