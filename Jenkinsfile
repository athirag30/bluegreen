pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "athira12/blue-green-node:latest"
        BLUE = "docker-compose-blue.yml"
        GREEN = "docker-compose-green.yml"
    }

    stages {
        stage("Clone Code") {
            steps {
                git 'https://github.com/your-repo/node-blue-green.git'
            }
        }
        stage("Build Docker Image") {
            steps {
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }
        stage("Push to Docker Hub") {
            steps {
                sh "docker push $DOCKER_IMAGE"
            }
        }
        stage("Deploy Blue") {
            steps {
                sh "docker-compose -f $BLUE up -d"
            }
        }
        stage("Health Check Blue") {
            steps {
                script {
                    sleep(5)
                    sh "curl -f http://localhost:3001/"
                }
            }
        }
        stage("Switch Traffic to Blue + Stop Green") {
            steps {
                sh "docker-compose -f $GREEN down || true"
            }
        }
    }
}
