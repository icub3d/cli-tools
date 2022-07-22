pipeline {
  agent {
    kubernetes {
      containerTemplate {
        name 'go'
          image 'golang:latest'
          command 'sleep'
          args 'infinity'
      }
      containerTemplate {
        name 'rust'
          image 'rust:latest'
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
                sh 'make go-tools'
            }
          }
        }
        stage('rust-binaries') {
          steps {
            container('rust') {
                sh 'make rust-tools'
            }
          }
        }
      }
    }
  }
}
