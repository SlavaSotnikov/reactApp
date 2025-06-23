pipeline {
  agent any
  stages {
    stage('Build image') {
      steps {
        sh '''
                  apt-get update -qq && \
                  apt-get install -y -qq ca-certificates curl gnupg
                  
                  # 1) ключ
                  install -m 0755 -d /etc/apt/keyrings
                  curl -fsSL https://download.docker.com/linux/$(. /etc/os-release && echo "$ID")/gpg \
                       -o /etc/apt/keyrings/docker.asc
                  chmod a+r /etc/apt/keyrings/docker.asc
                  
                  # 2) сам репозиторій
                  echo \
                    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
                    https://download.docker.com/linux/$(. /etc/os-release && echo "$ID") \
                    $(. /etc/os-release && echo ${VERSION_CODENAME:-$UBUNTU_CODENAME}) stable" \
                    > /etc/apt/sources.list.d/docker.list
                  
                  apt-get update -qq
                  
                  # 3) потрібні пакети — досить лише CLI-плагінів
                  apt-get install -y -qq docker-buildx-plugin docker-compose-plugin

                  # збірка + завантаження результату в локальний daemon
                  docker buildx build --load -t react-app:${BUILD_NUMBER} -t react-app:latest .
                '''

        // sh """
        //   export DOCKER_BUILDKIT=1
        //   docker build -t react-app:${BUILD_NUMBER} -t react-app:latest .
        // """
      }
    }
  }
  // post {
  //   success {
  //     // тригер без очікування
  //     build job: 'compose-pipeline', wait: false
  //   }
  // }
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
