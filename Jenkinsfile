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
          println jiraVersion.toString()
          // if ( jiraVersion ) {
          //   println "${jiraVersion}"
          // } else {
          //   println "Creating JIRA Version"
          // }
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
