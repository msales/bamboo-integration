@Library('msales-jenkins-libraries') _

pipeline {
  agent { label "optimizer-ui" }

  options {
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5'))
  }

  environment {
    SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/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"
    JIRA_PROJECT = "BLT"
    def git_tag = sh(returnStdout: true, script: 'git describe --tags').trim()
    def git_tag_old = sh(returnStdout: true, script: 'git describe --tags --abbrev=0 HEAD^').trim()
    def git_log = sh(returnStdout: true, script: 'git log 2.3.1..HEAD --oneline | grep -Eo '([A-Z]{3,}-)([0-9]+)' | uniq').trim()
  }

  stages {
    stage('Checkout') {
      steps {
        sh 'env'
        script {
          println git_tag
          println git_tag_old
          println git_log

          jiraVersion(git_tag, JIRA_PROJECT)
          jiraTicketsFromLog(git_log)
        }
      }
    }
    stage('Deploy') {
      steps {
        sh 'env'
        println git_log
      }
    }
  }
}
