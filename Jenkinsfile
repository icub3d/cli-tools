pipeline {
  triggers {
    cron('TZ=America/Denver\nH 4 * * 0')
  }
  agent {
    kubernetes {
      yamlFile 'build-pods.yaml'
    }
  }
  stages {
    stage ('build binaries') {
      parallel {
        stage('go-binaries') {
          steps {
            container('go') {
              sh 'make go-tools copy-go-tools'
            }
          }
        }
        stage('rust-binaries') {
          steps {
            container('rust') {
              sh 'make rust-tools copy-rust-tools'
            }
          }
        }
      }
    }
    stage ('zip binaries') {
      steps {
        container('go') {
          withCredentials([usernamePassword(credentialsId: 'wasabi-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
            sh 'make zip-files send-to-wasabi'
          }
        }
      }
    }
  }
}
