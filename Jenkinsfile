pipeline {
  agent any
  stages {
    stage('Clone') {
      steps {
        git(url: 'https://github.com/bliekp/BrouwHulp.git', branch: '$GIT_BRANCH')
        stash(name: 'scm', includes: '*')
      }
    }
    stage('Build in Docker') {
      steps {
        unstash 'scm'
        script {
          docker.image('taraworks/lazarus-cross:0.0.2').inside{
            sh 'pwd'
            sh 'ls -altrh'
            sh 'fpc -va hello.pas'
            sh 'ls -altrh'
          }
        }

      }
    }
  }
}