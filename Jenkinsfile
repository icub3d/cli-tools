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
              git branch: 'main', poll: false, url: 'https://git.marsh.gg/marshians/cli-tools'
                sh 'make go-tools'
            }
          }
        }
        stage('rust-binaries') {
          steps {
            container('rust') {
              git branch: 'main', poll: false, url: 'https://git.marsh.gg/marshians/cli-tools'
                sh 'make rust-tools'
            }
          }
        }
      }
    }
  }
}
