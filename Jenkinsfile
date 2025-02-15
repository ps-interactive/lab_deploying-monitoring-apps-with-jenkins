pipeline {
    agent any
    stages {
        stage('Prepare') {
            steps {
		echo 'Backing up current myapp:latest as myapp:previous if it exists ...'
		sh '''if docker images | awk \'{print $1":"$2}\' | grep -q myapp:previous; then docker rmi myapp:previous; fi'''
		sh '''if docker images | awk \'{print $1":"$2}\' | grep -q myapp:latest; then docker tag myapp:latest myapp:previous; fi'''

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
    }
}
