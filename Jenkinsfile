pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        input(message: 'Deploy to STAGING ? ', id: 'deploy_stage ', ok: 'Yes')
      }
    }
  }
  environment {
    SLACK_WEBHOOK_URL = 'https://hooks.slack.com/services/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'
    JIRA_PROJECT = 'BLT'
    git_tag = sh(returnStdout: true, script: 'git describe --tags').trim()
    git_tag_old = sh(returnStdout: true, script: 'git describe --tags --abbrev=0 HEAD^').trim()
  }
  options {
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5'))
  }
}