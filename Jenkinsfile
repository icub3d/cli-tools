pipeline {
  triggers {
    cron('''# For our local time
           |TZ=America/Denver
           |H 4 * * *'''.stripMargin())
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
          sh 'make zip-files'
        }
      }
    }
  }
}
