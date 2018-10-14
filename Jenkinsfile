pipeline {
  agent any
  stages {
    stage('Clone') {
      steps {
        git(branch: 'development', url: 'https://github.com/bliekp/BrouwHulp.git')
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