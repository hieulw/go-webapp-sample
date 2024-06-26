pipeline {
  agent {
    label 'docker'
  }

  tools {
    go '1.22'
  }

  environment {
    GOLINT = tool 'golangci-lint'
    SONAR  = tool 'sonarqube-scanner'
    GIT_URL = 'https://github.com/hieulw/go-webapp-sample.git'
    APP_NAME = 'go-webapp-sample'
    RELEASE = '1.5.7'
    DOCKER_USER = 'ladyga14'
    DOCKER_PASS = 'dockerhub-token'
  }

  stages {
    stage('Git Checkout') {
      steps {
        git branch: 'master', url: GIT_URL
      }
    }

    stage('Golang CI Lint') {
      steps {
        withEnv(["PATH+=${GOLINT}/bin"]) {
          sh 'golangci-lint -v run --config=.github/.golangci.yml'
        }
      }
    }

    stage('Test Coverage') {
      steps {
        sh 'go test -v ./controller ./model/dto ./service ./util -coverprofile=coverage.out'
        sh 'go tool cover -func=coverage.out'
      }
    }

    stage('SonarQube Scanner') {
      steps {
        withEnv(["PATH+=${SONAR}/bin"]) {
          withSonarQubeEnv('sonar') {
            sh 'sonar-scanner -X'
          }
        }
      }
    }

    stage('Quality Gate') {
      steps {
        timeout(time: 5, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: true
        }
      }
    }

    stage('Build') {
      steps {
        script {
          docker.withRegistry('', DOCKER_PASS) {
            def dockerImage = docker.build("${env.DOCKER_USER}/${env.APP_NAME}")
            dockerImage.push("${env.RELEASE}")
          }
        }
      }
    }
  }

  post {
    always {
      cleanWs(
          cleanWhenNotBuilt: false,
          deleteDirs: true,
          notFailBuild: true,
          patterns: [
            [pattern: '.gitignore', type: 'INCLUDE'],
          ]
      )
    }
  }
}
