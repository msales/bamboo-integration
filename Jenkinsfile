pipeline {
  options { buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5')) }
  agent { label "optimizer-ui" }
  environment {
    JIRA_PROJECT = "BLT"
    GIT_COMMITS_LOG = "/tmp/bamboo-integration-git-commits.log"
  }
  stages {
    stage('Checkout') {
      steps {
        script {
          if (env.BRANCH_NAME == 'master' || env.BRANCH_NAME.startsWith('PR-')) {
            echo 'Not asking'
            def git_tag_old = sh(returnStdout: true, script: 'git describe --tags --abbrev=0 HEAD^').trim()
            sh("git log ${git_tag_old}..HEAD --oneline | grep -Eo '([A-Z0-9]{3,}-)([0-9]+)' | sort -u > ${GIT_COMMITS_LOG}")
          } else {
            env.DEPLOY_STAGING = input message: 'Deploy to STAGING ?', ok: 'Confirm', parameters: [choice(name: 'DEPLOY_STAGING', choices: 'Yes\nNo')]
          }
        }
        sh 'env'
      }
    }
    stage('JIRA') {
      steps {
        script {
          def git_tag = sh(returnStdout: true, script: 'git describe --tags').trim()
          def git_log = readFile("${GIT_COMMITS_LOG}")
          def jira_version = jiraVersion(git_tag, JIRA_PROJECT, "OUI", "create")
          jiraTicketsFromLog(git_log, jira_version)
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
          branch 'master';
          environment name: 'DEPLOY_STAGING', value: 'Yes'
        }
      }
      steps {
        script {
          def jobs_read = readFile("jobs")
          def jobs = jobs_read.split("\n")
          def builders = [:]
          jobs.each {
            stage -> builders[stage] = {
              echo stage
              echo "hello ${stage}"
              sh 'sleep 10'
            }
          }
          parallel builders
        }
      }
    }
    stage('Deploy Production') {
      steps {
        echo 'Test_NEW...'
      }
    }
  }
  post {
    always {
      junit 'build/*.xml'
      cleanWs notFailBuild: true
    }
    success {
      slackNotification('SUCCESSFUL', 'msales', 'optimizer-ui', env.BRANCH_NAME, SLACK_WEBHOOK_URL)
      // notify deployment slack channel
      slackNotification('SUCCESSFUL', 'msales', 'optimizer-ui', env.BRANCH_NAME, "https://hooks.slack.com/services/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")
      script {
        def git_tag = sh(returnStdout: true, script: 'git describe --tags').trim()
        jiraVersion(git_tag, JIRA_PROJECT, "OUI", "released")
      }
    }
    failure {
      slackNotification('FAILED', 'msales', 'optimizer-ui', env.BRANCH_NAME, SLACK_WEBHOOK_URL)
      // notify deployment slack channel
      slackNotification('FAILED', 'msales', 'optimizer-ui', env.BRANCH_NAME, "https://hooks.slack.com/services/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")
      sh "mysql -u root -e 'DROP DATABASE 'oui_phpunit_${env.GIT_COMMIT}''"
      sh "mysql -u root -e 'DROP DATABASE oui_behat_${env.GIT_COMMIT}'"
      sh "rm -rf /tmp/backups/oui_phpunit_${env.GIT_COMMIT}"
      sh "rm -rf /tmp/backups/oui_behat_${env.GIT_COMMIT}"
    }
    aborted {
      slackNotification('ABORTED', 'msales', 'optimizer-ui', env.BRANCH_NAME, SLACK_WEBHOOK_URL)
      // notify deployment slack channel
      slackNotification('ABORTED', 'msales', 'optimizer-ui', env.BRANCH_NAME, "https://hooks.slack.com/services/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")
      sh "mysql -u root -e 'DROP DATABASE 'oui_phpunit_${env.GIT_COMMIT}''"
      sh "mysql -u root -e 'DROP DATABASE oui_behat_${env.GIT_COMMIT}'"
      sh "rm -rf /tmp/backups/oui_phpunit_${env.GIT_COMMIT}"
      sh "rm -rf /tmp/backups/oui_behat_${env.GIT_COMMIT}"
    }
  }
}