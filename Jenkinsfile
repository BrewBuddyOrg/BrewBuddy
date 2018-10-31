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
//          docker.image('taraworks/lazarus-cross:0.0.2').inside('-u root -v /var/jenkins_home/.lazarus:/var/jenkins_home/.lazarus'){
          docker.image('taraworks/lazarus-cross:0.0.2').inside('-u root'){
            sh '/usr/bin/apt-get install -y libfann-dev'
            sh 'pwd'
            sh 'chown -R 1000:1000 .'
            sh 'pwd'
//            sh 'find . -name "*.o" -exec rm {} \\;'
//            sh 'find . -name "*.ppu" -exec rm {} \\;'
            sh 'cd Source && lazbuild --lazarusdir=/usr/share/lazarus/1.8.0 --add-package ./3rdParty/ExpandPanels/expandpanels-master-2/pexpandpanels.lpk'
            sh 'cd Source && lazbuild --lazarusdir=/usr/share/lazarus/1.8.0 --add-package ./3rdParty/uniqueinstance-1.0/uniqueinstance_package.lpk'
            sh 'cd Source && lazbuild --lazarusdir=/usr/share/lazarus/1.8.0 --add-package ./3rdParty/Synapse/source/lib/laz_synapse.lpk'
            sh 'cd Source && lazbuild --lazarusdir=/usr/share/lazarus/1.8.0 ./brewbuddy_linux-x64.lpi'
            sh 'cd Source && PATH=$PATH:/opt/clang/bin:/opt/osxcross/target/bin lazbuild --lazarusdir=/usr/share/lazarus/1.8.0 -B ./brewbuddy_win32.lpi --ws=win32 --cpu=i386 --os=win32 --compiler=/opt/windows/lib/fpc/3.0.4/ppcross386'
            sh 'chown -R 1000:1000 .'
          }
        }

      }
    }
  }
  
      post {
        always {
            echo ""
        }
	failure {
	    echo "Build FAILED..."
            echo "Now let's remove the stash:"
            script {
              docker.image('taraworks/lazarus-cross:0.0.2').inside('-u root -v /var/jenkins_home/.lazarus:/var/jenkins_home/.lazarus'){
                sh 'pwd && ls -altrh'
                sh 'rm -rf * .git .github'
                sh 'ls -altrh'
              }
            }
	}
        success {
//            notifySuccessful()
            archiveArtifacts artifacts: 'Output/brewbuddy', fingerprint: true
            archiveArtifacts artifacts: 'Output/brewbuddy.exe', fingerprint: true
            echo "SUCCESS!"
            script {
               docker.image('taraworks/lazarus-cross:0.0.2').inside('-u root -v /var/jenkins_home/.lazarus:/var/jenkins_home/.lazarus'){
                 sh 'pwd && ls -altrh'
                 sh 'rm -rf * .git .github'
                 sh 'ls -altrh'
               }
            }

        }
      }
}
