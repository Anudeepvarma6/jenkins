pipeline {

    agent any

    tools {
        jdk 'jdk17'
        maven 'maven3'
    }

    environment {
        IMAGE_NAME = "366476834058.dkr.ecr.ap-south-1.amazonaws.com/java-standalone"
        AWS_REGION = "ap-south-1"
    }

    stages {

        stage('Checkout') {
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

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t java-app .'
            }
        }

        stage('Push to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin $IMAGE_NAME

                docker tag java-app:latest $IMAGE_NAME:latest

                docker push $IMAGE_NAME:latest
                '''
            }
        }

        stage('Deploy Docker Container') {
            steps {
                sh '''
                docker stop java-container || true
                docker rm java-container || true

                docker run -d \
                --name java-container \
                -p 8081:8080 \
                $IMAGE_NAME:latest
                '''
            }
        }

    }

}
