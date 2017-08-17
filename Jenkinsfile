@Library('msales-jenkins-libraries') _

pipeline {
  agent { label "optimizer-ui" }

  options {
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5'))
  }

  environment {
    SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/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"
  }

  stages {
    stage('Checkout') {
      steps {
        sh 'env'
        script {
          def git_tag = sh(returnStdout: true, script: 'git describe --tags').trim()
          def jiraVersion = jiraGetVersion failOnError: false, id: "${git_tag}", site: 'msales'
          if ( jiraVersion.successful ) {
            println "${jiraVersion}"
          } else {
            def blt_new_version = [ name: "${git_tag}",
                        archived: false,
                        released: false,
                        description: "OUI Version: ${git_tag}",
                        project: 'BLT' ]
            jiraNewVersion version: blt_new_version, site: 'msales'
          }
        }
      }
    }
  }
  post {
    always {
      cleanWs notFailBuild: true
    }
  }
}
