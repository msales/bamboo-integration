pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        script {
          if (env.BRANCH_NAME == 'master' || env.BRANCH_NAME.startsWith('PR-')) {
            echo 'Not asking'
          } else {
            env.DEPLOY_STAGING = input message: 'Deploy to STAGING ?', ok: 'Confirm', parameters: [choice(name: 'DEPLOY_STAGING', choices: 'Yes\nNo')]
          }
        }
      }
    }
    stage('Test') {
      steps {
        sh 'env'
        echo 'Test'
      }
    }
    stage('Deploy Staging') {
      when {
        anyOf {
          branch 'jenkins';
          environment name: 'DEPLOY_STAGING', value: 'Yes'
        }
      }
      steps {
        echo 'Deploying'
      }
    }
    stage('Deploy Production') {
      steps {
        echo 'Test_NEW...'
      }
    }
    stage('Merging branches') {
      steps {
        echo 'Merging master -> hotfix...'
        sh 'git fetch -a'
        sh 'git branch'
        sh 'git checkout hotfix'
        sh 'git merge origin/master'
        sh 'git push'
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
  post {
    always {
      cleanWs notFailBuild: true
    }
  }
}