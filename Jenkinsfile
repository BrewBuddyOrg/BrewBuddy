pipeline {
  agent any
  stages {
    stage('BrouwHulp Build') {
      steps {
        git(url: 'https://github.com/bliekp/BrouwHulp.git', changelog: true, branch: 'development')
      }
    }
    stage('error') {
      steps {
        sh 'docker exec pascalContainer bash -c "cd /var/services/homes/pim/Docker/pascal_files && fpc -va hello.pas"'
      }
    }
  }
}