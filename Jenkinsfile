pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = "python-app"
        DOCKER_IMAGE_TAG  = "${env.BUILD_NUMBER}"
        KIND_CLUSTER_NAME = "devops-lab"
    }

    stages {
        stage('Build') {
            steps {
                script {
                    echo "Building Docker image..."
                    docker.build("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}", '.')
                    docker.build("${DOCKER_IMAGE_NAME}:latest", '.')
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo "Running health check..."
                    def container = docker.run("${DOCKER_IMAGE_NAME}:latest")
                    sleep 5 // Give the container a moment to start
                    def health = sh(script: "curl -s http://${container.ipAddress()}:5000/health", returnStatus: true)
                    container.stop()
                    if (health != 0) {
                        error "Health check failed!"
                    }
                    echo "Health check passed."
                }
            }
        }

        stage('Deploy to Kind') {
            steps {
                script {
                    echo "Deploying to Kind cluster..."
                    // Load the image into the Kind cluster
                    sh "kind load docker-image ${DOCKER_IMAGE_NAME}:latest --name ${KIND_CLUSTER_NAME}"
                    
                    // Update the deployment with the new image
                    sh "kubectl set image deployment/python-app-deployment python-app-container=${DOCKER_IMAGE_NAME}:latest"
                    
                    echo "Deployment updated."
                }
            }
        }
    }
}
