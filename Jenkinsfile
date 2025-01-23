pipeline {
    agent any
    
    environment {
        APP_NAME = 'guestbook'
        DOCKER_IMAGE = "guestbook:${BUILD_NUMBER}"
        BACKUP_IMAGE = "guestbook:previous"
        DEPLOY_DIR = '/var/www/guestbook'
        BACKUP_DIR = '/var/www/guestbook_backup'
    }
    
    stages {
        stage('Prepare') {
            steps {
                script {
                    // Clean workspace
                    cleanWs()
                    // Checkout code
                    checkout scm
                    
                    // Install dependencies
                    sh 'npm ci'
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    try {
                        // Run linting
                        sh 'npm run lint'
                        
                        // Run tests (when we add them)
                        // sh 'npm test'
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error "Test stage failed: ${e.message}"
                    }
                }
            }
        }
        
        stage('Build') {
            steps {
                script {
                    try {
                        // Build React application
                        sh 'npm run build'
                        
                        // Build Docker image
                        sh """
                            docker build -t ${DOCKER_IMAGE} .
                            docker tag ${DOCKER_IMAGE} ${BACKUP_IMAGE}
                        """
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error "Build stage failed: ${e.message}"
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    try {
                        // Create backup of current deployment
                        sh """
                            if [ -d "${DEPLOY_DIR}" ]; then
                                rm -rf ${BACKUP_DIR}
                                cp -r ${DEPLOY_DIR} ${BACKUP_DIR}
                            fi
                        """
                        
                        // Stop existing container if running
                        sh '''
                            if docker ps -q --filter "name=${APP_NAME}"; then
                                docker stop ${APP_NAME}
                                docker rm ${APP_NAME}
                            fi
                        '''
                        
                        // Run new container
                        sh """
                            docker run -d \
                                --name ${APP_NAME} \
                                -p 3000:3000 \
                                --restart unless-stopped \
                                ${DOCKER_IMAGE}
                        """
                        
                        // Health check
                        sh '''
                            for i in {1..30}; do
                                if curl -s http://localhost:3000 > /dev/null; then
                                    echo "Application is up and running"
                                    exit 0
                                fi
                                sleep 2
                            done
                            echo "Application failed to start"
                            exit 1
                        '''
                    } catch (Exception e) {
                        // Trigger rollback
                        error "Deploy stage failed: ${e.message}"
                    }
                }
            }
        }
    }
    
    post {
        failure {
            script {
                echo "Deployment failed, initiating rollback..."
                
                // Restore previous container
                sh """
                    docker stop ${APP_NAME} || true
                    docker rm ${APP_NAME} || true
                    docker run -d \
                        --name ${APP_NAME} \
                        -p 3000:3000 \
                        --restart unless-stopped \
                        ${BACKUP_IMAGE}
                """
                
                // Restore backup files
                sh """
                    if [ -d "${BACKUP_DIR}" ]; then
                        rm -rf ${DEPLOY_DIR}
                        mv ${BACKUP_DIR} ${DEPLOY_DIR}
                    fi
                """
                
                echo "Rollback completed"
            }
        }
        
        cleanup {
            // Clean up old docker images
            sh '''
                docker image prune -f
                docker container prune -f
            '''
        }
    }
}