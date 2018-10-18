//def notifySuccessful() {
//  slackSend (color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
//}

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
          docker.image('taraworks/lazarus-cross:0.0.2').inside('-u root -v /root/.lazarus:/root/.lazarus'){
            sh 'ls -al /root/ && pwd'
            sh '/usr/bin/apt-get install -y libfann-dev'
            sh 'pwd'
            sh 'find . -name "*.o" -exec rm {} \;
            sh 'find . -name "*.ppu" -exec rm {} \;
            sh 'rm brouwhulp'
            sh 'lazbuild --verbose --add-package ExpandPanels/expandpanels-master-2/pexpandpanels.lpk'
            sh 'lazbuild --verbose --add-package uniqueinstance-1.0/uniqueinstance_package.lpk'
            sh 'lazbuild --verbose --add-package Synapse/source/lib/laz_synapse.lpk'
            sh 'lazbuild --verbose brouwhulp.lpi'
          }
        }

      }
    }
  }
  
      post {
        always {
            archiveArtifacts artifacts: 'brouwhulp', fingerprint: true
        }
        success {
//            notifySuccessful()
            echo "SUCCESS!"
        }
      }
}
