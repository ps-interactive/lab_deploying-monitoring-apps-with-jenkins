pipeline {
    agent any
    stages {
        stage('Prepare') {
            steps {
                echo 'Cleaning up old Docker images...'
                sh 'docker system prune -af || true'
            }
        }
        stage('Test') {
            steps {
                echo 'Skipping tests for static website...'
            }
        }
        stage('Build') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t myapp:latest .'
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Determine active container and new container name
                    def activeContainer = sh(script: "docker ps --filter 'name=myapp-green' --filter 'name=myapp-blue' --format '{{.Names}}'", returnStdout: true).trim()
                    def newContainer = activeContainer == 'myapp-blue' ? 'myapp-green' : 'myapp-blue'

                    // Check if the old container is running on port 80
                    def isPort80Active = sh(script: "docker ps --filter 'name=${activeContainer}' --filter 'publish=80' --format '{{.Names}}'", returnStdout: true).trim()

                    if (isPort80Active) {
                        // Deploy the new container on port 81
                        echo "Deploying new container: ${newContainer} on port 81"
                        sh "docker run -d --name ${newContainer} -p 81:80 myapp:latest"

                        // Validate that the new container is running
                        def newContainerStatus = sh(script: "docker ps --filter 'name=${newContainer}' --format '{{.Status}}'", returnStdout: true).trim()
                        if (!newContainerStatus) {
                            error "New container ${newContainer} is not running. Aborting deployment."
                        }

                        // Stop and remove the old container on port 80
                        echo "Stopping and removing old container: ${activeContainer}"
                        sh "docker stop ${activeContainer} || true"
                        sh "docker rm ${activeContainer} || true"

                        // Restart the new container on port 80
                        echo "Starting new container ${newContainer} on port 80"
                        sh "docker stop ${newContainer} || true"
			sh "docker rm ${newContainer} || true"
                        sh "docker run -d --name ${newContainer} -p 80:80 myapp:latest bash -c 'exit 1'"
                    } else {
                        // Deploy directly to port 80 if no active container
                        echo "No active container found on port 80. Deploying ${newContainer} on port 80"
                        sh "docker run -d --name ${newContainer} -p 80:80 myapp:latest bash -c 'exit 1'"
                    }
                }
            }
        }
        stage('Rollback') {
            when {
                expression { return currentBuild.result == 'FAILURE' }
            }
            steps {
                script {
                    def failedContainer = sh(script: "docker ps --filter 'name=myapp-green' --filter 'name=myapp-blue' --format '{{.Names}}'", returnStdout: true).trim()
                    def rollbackContainer = failedContainer == 'myapp-green' ? 'myapp-blue' : 'myapp-green'
                    echo "Rolling back to previous container: ${rollbackContainer}"
                    sh "docker start ${rollbackContainer}"
                    sh "docker stop ${failedContainer} || true"
                    sh "docker rm ${failedContainer} || true"
                }
            }
        }
    }
}
