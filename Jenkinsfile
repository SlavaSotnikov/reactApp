pipeline {
  agent any
  stages {
    stage('Build image') {
      steps {
        sh """
          docker buildx build -t react-app:${BUILD_NUMBER} -t react-app:latest .
        """
      }
    }
  }
  post {
    success {
      // тригер без очікування
      build job: 'compose-pipeline', wait: false
    }
  }
}


// pipeline {
//     agent any
//     tools { nodejs 'node18' }
//     options { timestamps() }

//     environment {
//         IMAGE_NAME = "react-app"
//         TAG        = "${BUILD_NUMBER}"
//         NETWORK    = "products-net"
//         PORT       = "3000"
//         API_URL    = "http://93.175.206.119:8080/api"   // одна адреса й для проксі
//     }

//     stages {

//         stage('Checkout') {
//             steps { checkout scm }
//         }

//         /* 1️⃣: локальна npm-збірка більше не потрібна */
//         /*       CRA збирається усередині Dockerfile     */

//         stage('Docker build & run') {
//             steps {
//                 sh """
//                    # створюємо .env, щоб CRA/Vite бачила змінну
//                    echo "REACT_APP_BASE_URL=${API_URL}" > .env

//                    docker rm -f ${IMAGE_NAME} || true

//                    docker build \\
//                      --build-arg REACT_APP_BASE_URL=${API_URL} \\
//                      -t ${IMAGE_NAME}:${TAG} -t ${IMAGE_NAME}:latest .

//                    docker run -d --name ${IMAGE_NAME} \\
//                      --network ${NETWORK} \\
//                      --restart unless-stopped \\
//                      -p ${PORT}:80 ${IMAGE_NAME}:latest
//                 """
//             }
//         }

//         /* 2️⃣: простий smoke-тест, що бекенд видно через проксі */
//         stage('Smoke test') {
//             steps {
//                 sh "curl -sf http://192.168.1.24:${PORT}/api/products || (echo 'API not reachable' && exit 1)"
//             }
//         }
//     }

//     post {
//         success { echo "✅ Frontend deployed on :${PORT}" }
//         failure { echo "❌ Frontend build/deploy failed" }
//     }
// }
