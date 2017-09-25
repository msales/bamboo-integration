pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        try {
            input(message: 'Deploy STAGING ? ', id: 'deploy_staging', ok: 'Yes')
        }
        catch (exc) {
            echo 'Something failed, I should sound the klaxons!'
            environment {
              deploy_staging = 'True'
            }
        }
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