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

                echo 'Cleaning up old Docker images and container fro previous deploymemnt...'
               sh '''docker stop `docker ps -a | grep myapp | awk \'{print $13}\'`|| true'''
               sh '''docker rm `docker ps -a | grep myapp | awk \'{print $13}\'`|| true'''
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
                        sh "docker run -d --name myapp -p 80:80 myapp:latest"
                    }
                }
            }
        stage('Rollback') {
            when {
                expression { BUILD_STATUS == 'FAILURE' }
            }
            steps {
                script {
                    echo "Rolling back to previous working image."

                    // Stop and remove the failed container
                    sh "docker stop myapp || true"
                    sh "docker rm myapp || true"

                    // Redeploy the previous working image
                    sh "docker run -d --name myapp -p 80:80 myapp:previous"

                    // Validate rollback container
                    def statusCode = sh(script: "curl -s -o /dev/null -w '%{http_code}' http://host.docker.internal", returnStdout: true).trim()
                    if (statusCode != '200') {
                        error "Rollback failed. Previous container myapp is not healthy (status: ${statusCode})."
                    } else {
                        echo "Rollback successful. myapp is running and healthy."
                    }
                }
            }
        }
    }
}
