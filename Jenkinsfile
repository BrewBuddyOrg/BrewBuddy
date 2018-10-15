pipeline {
  agent any
  stages {
    stage('Clone') {
      steps {
        stash(name: 'scm', includes: '*')
        git(url: 'https://github.com/bliekp/BrouwHulp.git', branch: "${env.BRANCH_NAME}", changelog: true, poll: true)
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
  
post {
        always {
            archiveArtifacts artifacts: 'hello', fingerprint: true
        }
        if (currentBuild.result == 'success') {
            echo "currentBuild.result: ${currentBuild.result}"
            slackSend channel: channel, color: 'good', teamDomain: null, token: null, message: "*${env.JOB_NAME}* Finished Successfuly! :thumbsup: ${jlink}(<!here|here>/${ulink})"
        }
    }
  
}
