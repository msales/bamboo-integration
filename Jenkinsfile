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
        slackNotification('STARTED', 'msales', 'bamboo-integration', SLACK_WEBHOOK_URL)
        sh 'env'
        script {
          def git_tag = sh(returnStdout: true, script: 'git describe --tags').trim()
          def jiraVersion = jiraGetVersion failOnError: false, id: "${git_tag}", site: 'msales'
          println jiraVersion.ResponseData.successful.toString()
          echo "VERSION: ${git_tag}"
          if ( jiraVersion ) {
            println "${jiraVersion}"
          } else {
            println "Creating JIRA Version"
          }
        }
      }
    }
    stage('Build') {
      steps {
        echo "Building..."
      }
    }
    stage('Staging') {
      when {
        anyOf {
          branch 'master';
          branch 'candidate'
        }
      }
      steps {
        // get lists of hosts from ansible
        echo "Deploying to STAGING"
      }
    }
    stage('Test') {
      steps {
        echo "Testing..."
      }
    }
    stage('Production') {
      when {
        anyOf {
          branch 'master';
          branch 'candidate'
        }
      }
      steps {
        input id: 'Deploy_staging', message: 'Deploy to PRODUCTION ?'
        // get lists of hosts from ansible
        echo "LAMBDA: aws_jira_version_deploy_webhook"
      }
    }
  }
  post {
    always {
      cleanWs notFailBuild: true
    }
    success {
      slackNotification('SUCCESSFUL', 'msales', 'bamboo-integration', SLACK_WEBHOOK_URL)
    }
    failure {
      slackNotification('FAILED', 'msales', 'bamboo-integration', SLACK_WEBHOOK_URL)
    }
    aborted {
      slackNotification('ABORTED', 'msales', 'bamboo-integration', SLACK_WEBHOOK_URL)
    }
  }
}
