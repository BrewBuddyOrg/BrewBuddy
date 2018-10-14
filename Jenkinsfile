pipeline {
  agent any
  stages {
    stage('Get from git') {
      steps {
        git(url: 'https://github.com/bliekp/BrouwHulp.git', changelog: true, branch: 'development')
      }
    }
    stage('Build') {
      steps {
        sh 'docker exec pascalContainer bash -c "cd /var/services/homes/pim/Docker/pascal_files && ls -altrh"'
      }
    }
  }
}