pipeline {
  agent any

  tools {
    nodejs "node18"
  }

  stages {
    stage('Clone') {
      steps {
        git 'https://github.com/SlavaSotnikov/reactApp.git'
      }
    }
    stage('Install') {
      steps {
        sh 'npm install'
      }
    }
    stage('Build') {
      steps {
        sh 'npm run build'
      }
    }
    stage('Docker') {
      steps {
        writeFile file: '.env', text: 'REACT_APP_BASE_URL=http://api:8080/api'
        sh 'docker build -t react-app .'
        sh 'docker-compose up -d --build frontend'
      }
    }
  }
}
