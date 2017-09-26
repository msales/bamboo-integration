pipeline {
  agent { label "optimizer-ui" }
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
        sh 'env'
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
      when {
        anyOf {
          branch 'master';
          branch 'hotfix'
        }
      }
      steps {
        sshagent(['a5c95e02-fd03-4e55-8109-78534e97e042']) {
          echo 'Merging master -> hotfix...'
          sh 'git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/*'
          sh 'git fetch -a'
          sh 'git branch -a'
          script {
            if (env.BRANCH_NAME == 'master') {
              sh 'git checkout hotfix'
              catchError {
                sh 'git merge origin/master'
              }
            } else if (env.BRANCH_NAME == 'hotfix') {
              sh 'git checkout master'
              catchError {
                sh 'git merge origin/master'
              }
            }
          }
          sh 'git push'
        }
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