pipeline {
  agent any
  stages {
    stage('Get from GitHub') {
      steps {
        dir(path: '/var/services/homes/pim/Docker/pascal_files')
        git(url: 'https://github.com/bliekp/BrouwHulp.git', branch: 'development')
      }
    }
    stage('Build') {
      steps {
        sh 'docker exec pascalContainer bash -c "cd /var/services/homes/pim/Docker/pascal_files && pwd && ls -altrh && fpc -va hello.pas"'
      }
    }
    stage('error') {
      steps {
        archiveArtifacts(allowEmptyArchive: true, caseSensitive: true, onlyIfSuccessful: true, artifacts: 'hello')
      }
    }
  }
}