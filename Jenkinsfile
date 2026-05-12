pipeline {

    agent any

    triggers {
        githubPush()
    }

    tools {
        jdk 'jdk21'
        maven 'maven3'
    }

    environment {
        AWS_REGION = "ap-south-1"
        ECR_REPO = "366476834058.dkr.ecr.ap-south-1.amazonaws.com/java-standalone"
        IMAGE_TAG = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master',
                url: 'https://github.com/Anudeepvarma6/jenkins.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                docker build -t java-app .
                docker tag java-app:latest $ECR_REPO:$IMAGE_TAG
                '''
            }
        }

        stage('Push to AWS ECR') {
            steps {

                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'AWS_CRED'
                ]]) {

                    sh '''
                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin $ECR_REPO

                    docker push $ECR_REPO:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker stop java-container || true
                docker rm java-container || true

                docker run -d \
                --name java-container \
                -p 6000:5000 \
                $ECR_REPO:$IMAGE_TAG
                '''
            }
        }
    }

    post {
        success {
            echo 'Application deployed successfully!'
        }

        failure {
            echo 'Pipeline failed!'
        }
    }
}
