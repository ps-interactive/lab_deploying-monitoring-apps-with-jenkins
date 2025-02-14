pipeline {
    agent any
    environment {
        BUILD_STATUS = 'SUCCESS'
    }
    stages {
        stage('Prepare') {
            steps {
		echo 'Backing up current myapp:latest as myapp:previous if it exists ...'
		sh '''if docker images | awk \'{print $1":"$2}\' | grep -q myapp:latest; then docker tag myapp:latest myapp:previous; fi'''

                echo 'Cleaning up old Docker images...'
               // sh 'docker system prune -af || true'
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

                        // Stop and remove the old container on port 80
                        echo "Stopping and removing old container: ${activeContainer}"
                        sh "docker stop ${activeContainer} || true"
                        sh "docker rm ${activeContainer} || true"

                        // Restart the new container on port 80
                        echo "Starting new container ${newContainer} on port 80"
                        sh "docker stop ${newContainer} || true"
                        sh "docker rm ${newContainer} || true"
                        sh "docker run -d --name ${newContainer} -p 80:80 myapp:latest"
                    } else {
                        // Deploy directly to port 80 if no active container
                        echo "No active container found on port 80. Deploying ${newContainer} on port 80"
                        sh "docker run -d --name ${newContainer} -p 80:80 myapp:latest"
                    }
                }
            }
        }
        stage('Verify Deployment') {
            steps {
                script {
                    // Check deployment status
                    def statusCode = sh(script: "curl -s -o /dev/null -w '%{http_code}' http://host.docker.internal", returnStdout: true).trim()
                    if (statusCode != '200') {
                        echo "Deployment failed with status: ${statusCode}. Setting build status to FAILURE."
                        BUILD_STATUS = 'FAILURE'
                        error "Triggering rollback."
                    } else {
                        echo "Deployment successful with status: ${statusCode}"
                    }
                }
            }
        }
        stage('Rollback') {
            when {
                expression { BUILD_STATUS == 'FAILURE' }
            }
            steps {
                script {
                    def failedContainer = sh(script: "docker ps --filter 'name=myapp-green' --filter 'name=myapp-blue' --format '{{.Names}}'", returnStdout: true).trim()
                    def rollbackContainer = failedContainer == 'myapp-green' ? 'myapp-blue' : 'myapp-green'

                    echo "Rolling back to previous working image."

                    // Stop and remove the failed container
                    sh "docker stop ${failedContainer} || true"
                    sh "docker rm ${failedContainer} || true"

                    // Redeploy the previous working image
                    sh "docker run -d --name ${rollbackContainer} -p 80:80 myapp:previous"

                    // Validate rollback container
                    def statusCode = sh(script: "curl -s -o /dev/null -w '%{http_code}' http://host.docker.internal", returnStdout: true).trim()
                    if (statusCode != '200') {
                        error "Rollback failed. Previous container ${rollbackContainer} is not healthy (status: ${statusCode})."
                    } else {
                        echo "Rollback successful. ${rollbackContainer} is running and healthy."
                    }
                }
            }
        }
    }
}
