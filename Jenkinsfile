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
                sh 'docker builb -t myapp:latest .'
            }
        }
        stage('Deploy') {
            steps {
                script {
                    def activeContainer = sh(script: "docker ps --filter 'name=myapp-green' --filter 'name=myapp-blue' --format '{{.Names}}'", returnStdout: true).trim()
                    def newContainer = activeContainer == 'myapp-blue' ? 'myapp-green' : 'myapp-blue'
                    echo "Deploying new container: ${newContainer}"
                    sh "docker run -d --name ${newContainer} -p 80:80 myapp:latest"
                    echo 'Switching traffic...'
                    sh "docker stop ${activeContainer} || true"
                    sh "docker rm ${activeContainer} || true"
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

