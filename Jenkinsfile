pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        script {
          def deploy_staging = catchError() { input(message: 'Deploy STAGING ?', id: 'deploy_staging')}
        }
        sh 'env'
      }
    }
    stage('Test') {
      steps {
        echo 'Test'
      }
    }
    stage('Deploy Staging') {
      steps {
        script {
          if (env.BRANCH_NAME == 'master') {
            echo 'Deploy to STAGING'
          } else {
            echo 'I execute elsewhere'
          }
        }
        
      }
    }
    stage('Deploy Production') {
      steps {
        echo 'production'
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