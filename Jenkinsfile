pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        input(message: 'Deploy STAGING ? ', id: 'deploy_staging', ok: 'Yes')
        sh 'env'
      }
    }
    stage('Test') {
      steps {
        echo 'Test'
      }
    }
  }
  environment {
    SLACK_WEBHOOK_URL = 'https://hooks.slack.com/services/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'
    JIRA_PROJECT = 'BLT'
  }
  options {
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5'))
  }
}