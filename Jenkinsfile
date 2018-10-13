pipeline {
  agent any
  stages {
    stage('BrouwHulp Build') {
      steps {
        git(url: 'https://github.com/bliekp/BrouwHulp.git', changelog: true, branch: 'development')
      }
    }
  }
}