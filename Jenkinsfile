pipeline {
    agent any

    environment {
        DOCKERHUB_REPO = "athira12/blue-green-node"
        DOCKERHUB_CREDENTIALS = "docker-hub-login"  // Jenkins credentials ID
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/athirag30/bluegreen.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = "${DOCKERHUB_REPO}:${env.BUILD_NUMBER}"
                    bat "docker build -t ${dockerImage} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        echo "Logged into Docker Hub ✅"
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    bat "docker push ${dockerImage}"
                }
            }
        }
    }

    post {
        success {
            echo "Docker Image pushed successfully: ${dockerImage} ✅"
        }
        failure {
            echo "Pipeline failed ❌"
        }
    }
}
