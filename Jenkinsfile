pipeline {
    agent any
    environment {
        DEPLOY_SERVER = 'user@server'
        APP_NAME = 'flask-app'
        BLUE_PORT = '5001'
        GREEN_PORT = '5002'
    }
    options {
        disableConcurrentBuilds()
    }
    stages {
        stage('Cleanup') {
            steps {
                echo 'Cleaning up workspace...'
                deleteDir()
            }
        }
        stage('Prepare') {
            steps {
                echo 'Setting up Python virtual environment and installing dependencies...'
                sh 'python -m venv venv'
                sh 'source venv/bin/activate && pip install -r requirements.txt'
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'source venv/bin/activate && pytest test_app.py'
            }
        }
        stage('Build') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t $APP_NAME .'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Starting Blue-Green Deployment...'
                sshagent(['your-ssh-credential-id']) {
                    // Tag and run the green instance
                    echo 'Tagging new green deployment...'
                    sh 'ssh $DEPLOY_SERVER docker tag $APP_NAME:latest $APP_NAME:green'
                    echo 'Starting green instance...'
                    sh 'ssh $DEPLOY_SERVER docker run -d --name flask-green -p $GREEN_PORT:$BLUE_PORT $APP_NAME:green'
                    
                    // Wait and check health
                    echo 'Waiting for green instance to start...'
                    sh 'sleep 10'
                    echo 'Checking health of green instance...'
                    sh 'if curl -f http://$DEPLOY_SERVER:$GREEN_PORT; then \
                        echo "Green instance is healthy. Switching traffic..."; \
                        ssh $DEPLOY_SERVER docker stop flask-blue || true; \
                        ssh $DEPLOY_SERVER docker rename flask-green flask-blue; \
                    else \
                        echo "Green instance failed. Rolling back..."; \
                        ssh $DEPLOY_SERVER docker rm -f flask-green; \
                        exit 1; \
                    fi'
                }
            }
        }
    }
    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed! Check logs and rollback if necessary.'
        }
    }
}
