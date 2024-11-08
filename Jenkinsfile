pipeline {
    agent any
    triggers {
    githubPush()
  }

    environment {
        DOCKER_IMAGE = "my-app"
        DOCKER_TAG = "${GIT_COMMIT}"
        REGISTRY = "docker.io"
        REPO = "AsHtrich/DOFinal"
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the GitHub repository
                checkout scm
            }
        }

        stage('Build and Test with Maven') {
            steps {
                // Run Maven build and tests
                sh 'mvn clean install'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build Docker image
                script {
                    docker.build("${REPO}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image to Registry') {
            steps {
                // Push the Docker image to Docker Hub
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        docker.image("${REPO}:${DOCKER_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to Development') {
            steps {
                script {
                    // Deploy to Dev environment (could be a Docker Compose or Kubernetes deployment)
                    sh 'docker run -d -p 8080:8080 ${REPO}:${DOCKER_TAG}'
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                script {
                    // Deploy to Staging environment (adjust based on your staging deployment)
                    sh 'docker run -d -p 8080:8080 ${REPO}:${DOCKER_TAG}'
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                script {
                    // Deploy to Prod environment (adjust based on your production deployment)
                    sh 'docker run -d -p 8080:8080 ${REPO}:${DOCKER_TAG}'
                }
            }
        }
    }

    post {
        always {
            // Clean up any unused images
            sh 'docker system prune -f'
        }
    }
}
