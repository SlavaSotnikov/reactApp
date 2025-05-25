// Jenkinsfile for client
pipeline {
    agent any

    tools { nodejs 'node18' }

    options { timestamps() }

    environment {
        IMAGE_NAME = "react-app"
        TAG        = "${BUILD_NUMBER}"
        NETWORK    = "products-net"
        PORT       = "3000"
        API_URL    = "http://192.168.1.24:8080/api"
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }        // або git URL, якщо не Multibranch
        }

        stage('Install deps') {
            steps { sh 'npm ci --ignore-scripts' }
        }

        stage('Build') {
            steps { sh "REACT_APP_BASE_URL=${API_URL} npm run build" }
        }

        stage('Docker build & run') {
            steps {
                script {
                    // готуємо .env, якщо Dockerfile його копіює
                    writeFile file: '.env', text: "REACT_APP_BASE_URL=${API_URL}\n"

                    sh """
                      docker rm -f ${IMAGE_NAME} || true
                      docker build -t ${IMAGE_NAME}:${TAG} -t ${IMAGE_NAME}:latest .
                      docker run -d --name ${IMAGE_NAME} \\
                        --network ${NETWORK} \\
                        --restart unless-stopped \\
                        -p ${PORT}:80 ${IMAGE_NAME}:latest
                    """
                }
            }
        }
    }

    post {
        success { echo "✅ Frontend deployed on :${PORT}" }
        failure { echo  "❌ Frontend build/deploy failed" }
        always  { sh 'rm -rf build || true' }
    }
}

