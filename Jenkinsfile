pipeline {
  agent any
  stages {
    stage('BrouwHulp Build') {
      steps {
        git(url: 'https://github.com/bliekp/BrouwHulp.git', changelog: true, branch: 'development')
      }
    }
    stage('') {
      steps {
        sh 'docker exec pascalContainer bash -c "cd ${CI_PROJECT_DIR} && fpc -va hello.pas"'
      }
    }
  }
}