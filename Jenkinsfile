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
              sh 'make copy-go-tools'
            }
          }
        }
        stage('rust-binaries') {
          steps {
            container('rust') {
              sh 'make rust-tools'
              sh 'make copy-rust-tools'
            }
          }
        }
      }
    }
    stage ('zip binaries') {
      steps {
        container('go') {
          sh 'make zip-files'
        }
        archiveArtifacts artifacts: '${WORKSPACE}/dist/*.zip', followSymlinks: false
      }
    }
  }
}
