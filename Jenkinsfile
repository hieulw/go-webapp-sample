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
        sh 'go clean -cache' // clean build
        sh 'go clean -testcache' // clean test
      }
    }

    stage('Lint') {
      steps {
        sh 'golangci-lint run --config=.github/.golangci.yml'
      }
    }

    stage('Test') {
      steps {
        sh 'go test ./... -coverprofile=coverage.out -covermode=atomic'
        sh 'go tool cover -html=coverage.out -o coverage.html'
      }
    }

    stage('SonarQube Scanner') {
      steps {
        withSonarQubeEnv('sonar') {
          sh 'sonar-scanner -Dsonar.projectKey=go-webapp-sample -Dsonar.sources=. -Dsonar.tests=. -Dsonar.exclusions=**/*_test.go -Dsonar.go.tests.reportPath=coverage.out'
        }
        script {
          waitForQualityGate abortPipeline: true, credentialsId: 'sonarqube'
        }
      }
    }

    stage('Build') {
      steps {
        sh 'go build'
      }
    }
  }
}
