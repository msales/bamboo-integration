@Library('msales-jenkins-libraries') _

pipeline {
  agent { label "optimizer-ui" }

  options {
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5'))
  }

  environment {
    SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/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"
    JIRA_PROJECT = "BLT"
  }

  stages {
    stage('Checkout') {
      steps {
        sh 'env'
        script {
          def git_tag = sh(returnStdout: true, script: 'git describe --tags').trim()
          def git_tag_old = sh(returnStdout: true, script: 'git describe --tags --abbrev=0 HEAD^').trim()
          sh("git log ${git_tag_old}..HEAD --oneline | grep -Eo '([A-Z0-9]{3,}-)([0-9]+)' | uniq >> git_commits.log")
          def git_log = readFile('git_commits.log')

          jiraVersion(git_tag, JIRA_PROJECT)
          jiraTicketsFromLog(git_log)
        }
      }
    }
    stage('Deploy') {
      steps {
        sh 'env'
        script {
          def git_log = readFile('git_commits.log')
          println git_log
        }
      }
    }
  }
}
