pipeline {
  agent {
    label 'docker'
  }

  tools {
    go '1.22'
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'master', url: 'https://github.com/hieulw/go-webapp-sample.git'
      }
    }

    stage('Clean') {
      steps {
        sh 'go clean' // clean build
        sh 'go clean -testcache' // clean test
      }
    }

    stage('Test') {
      steps {
        sh 'go test ./...'
      }
    }

    stage('Build') {
      steps {
        sh 'go build'
      }
    }
  }
}
