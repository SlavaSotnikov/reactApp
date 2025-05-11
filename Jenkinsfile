pipeline {
  agent any

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
        sh 'docker build -t react-app .'
        sh 'docker compose up -d --build frontend'
      }
    }
  }
}
