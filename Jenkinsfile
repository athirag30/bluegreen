pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "athira12"
        APP_NAME = "blue-green-node"
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
                   def dockerImage = docker.build("${DOCKERHUB_USER}/${APP_NAME}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', 'docker-hub-login') {
                        dockerImage.push()
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Blue-Green Deployment') {
            steps {
                script {
                    def current = sh(script: "docker ps --filter 'name=node-app' --format '{{.Names}}'", returnStdout: true).trim()

                    if (current == "node-app-blue") {
                        newApp = "node-app-green"
                        oldApp = "node-app-blue"
                    } else {
                        newApp = "node-app-blue"
                        oldApp = "node-app-green"
                    }

                    echo "Starting new container: ${newApp}"

                    sh """
                        docker run -d --name ${newApp} -p 3001:3000 ${DOCKERHUB_USER}/${APP_NAME}:latest

                        sleep 5

                        curl -f http://localhost:3001 || (docker logs ${newApp} && exit 1)

                        docker stop ${oldApp} || true
                        docker rm ${oldApp} || true

                        docker rename ${newApp} node-app
                    """
                }
            }
        }
    }
}
