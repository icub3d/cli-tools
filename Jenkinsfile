pipeline {
  agent {
    kubernetes {
      containerTemplate {
        name 'go'
          image 'golang:latest'
          command 'sleep'
          args 'infinity'
      }
    }
  }
  stages {
    stage ('build binaries') {
      parallel {
        stage('go-binaries') {
          steps {
            container('go') {
              git branch: 'main', url: 'https://git.marsh.gg/marshians/cli-tools'
                sh 'make go-tools'
            }
          }
        }
      }
    }
  }
}
