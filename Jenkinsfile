pipeline {
  agent any
  stages {
    stage('Allocate WS and fill with data from Git') {
      steps {
        ws(dir: '/var/services/homes/pim/Docker/pascal_files')
        dir(path: '/var/services/homes/pim/Docker/pascal_files')
        git(url: 'https://github.com/bliekp/BrouwHulp.git', branch: 'development', changelog: true, poll: true)
      }
    }
    stage('Build') {
      steps {
        sh 'docker exec pascalContainer bash -c "cd /var/services/homes/pim/Docker/pascal_files && pwd && ls -altrh && fpc -va hello.pas"'
      }
    }
    stage('') {
      steps {
        archiveArtifacts(allowEmptyArchive: true, caseSensitive: true, onlyIfSuccessful: true, artifacts: 'hello')
      }
    }
  }
}