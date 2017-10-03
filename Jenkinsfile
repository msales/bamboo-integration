@Library('msales-jenkins-libraries') _

pipeline {
  agent { label "optimizer-ui" }

  options {
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '5'))
  }

  environment {
    // SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/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"
    JIRA_PROJECT = "BLT"
    GIT_COMMITS_LOG = "/tmp/bamboo-integration-git-commits.log"
  }

  stages {
    stage('Checkout') {
      steps {
        // slackNotification('STARTED', 'msales', 'optimizer-ui', env.BRANCH_NAME, SLACK_WEBHOOK_URL)
        sh 'env'
        script {  
          if (env.BRANCH_NAME == 'master') {
            // notify deployment slack channel
            // slackNotification('STARTED', 'msales', 'optimizer-ui', env.BRANCH_NAME, "https://hooks.slack.com/services/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")
            def git_tag_old = sh(returnStdout: true, script: 'git describe --tags --abbrev=0 HEAD^').trim()
            sh("git log ${git_tag_old}..HEAD --oneline | grep -Eo '([A-Z0-9]{3,}-)([0-9]+)' | sort -u > ${GIT_COMMITS_LOG}")
          } else if (env.BRANCH_NAME == 'hotfix') {
            // notify deployment slack channel
            // slackNotification('STARTED', 'msales', 'optimizer-ui', env.BRANCH_NAME, "https://hooks.slack.com/services/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")
            def git_tag_old = sh(returnStdout: true, script: 'git describe --tags --abbrev=0 HEAD^').trim()
            sh("git log ${git_tag_old}..HEAD --oneline | grep -Eo '([A-Z0-9]{3,}-)([0-9]+)' | sort -u > ${GIT_COMMITS_LOG}")
            env.DEPLOY_STAGING = 'No'
          } else if (env.BRANCH_NAME.startsWith('PR-')) {
            env.DEPLOY_STAGING = 'No'
          } else {
            env.DEPLOY_STAGING = input message: 'Deploy to STAGING ?', ok: 'Confirm', parameters: [choice(name: 'DEPLOY_STAGING', choices: 'Yes\nNo')]
          }
        }
      }
    }
    stage('JIRA') {
      when {
        anyOf {
          branch 'master';
          branch 'hotfix'
        }
      }
      steps {
        script {
          def git_tag = sh(returnStdout: true, script: 'git describe --tags').trim()
          def git_log = readFile("${GIT_COMMITS_LOG}")
          def jira_version = jiraVersion(git_tag, JIRA_PROJECT, "OUI", "create")
          jiraTicketsFromLog(git_log, jira_version)
        }
      }
    }
    stage('Build') {
      steps {
        echo "Build Step"
      }
    }
    stage('Tests') {
      steps {
        parallel (
          "behat": {
            echo "Behat tests..."
            sh "sleep 2"
          },
          "phpunit": {
            echo "PHPUnit tests..."
            sh "sleep 2"
          }
        )
      }
    }
    stage('Build clean-up') {
      steps {
        echo "Build clean-up..."
      }
    }
    stage('Deploy: Staging') {
      when {
        anyOf {
          branch 'master';
          environment name: 'DEPLOY_STAGING', value: 'Yes'
        }
      }
      steps {
        script {
          def BUILD_NO = BUILD_ID as Integer
          def PREVIOUS_BUILD = BUILD_NO - 1
          def ansible_hosts = ["server01", "server02", "server03", "server04"]
          def builders = [:]
          ansible_hosts.each() {
            stage -> builders[stage] = {
              echo "Deoploying..."
              sh "sleep 2"
            }
          }
          parallel builders
        }
      }
    }
    stage('Deploy: Production') {
      when {
        anyOf {
          branch 'master';
          branch 'hotfix'
        }
      }
      steps {
        script {
          input id: 'Deploy_production', message: 'Deploy to PRODUCTION ?'
          def BUILD_NO = BUILD_ID as Integer
          def PREVIOUS_BUILD = BUILD_NO - 1
          def ansible_hosts = ["server01", "server02", "server03", "server04"]
          def builders = [:]
          ansible_hosts.each() {
            stage -> builders[stage] = {
              echo "Deoploying..."
              sh "sleep 2"
            }
          }
          parallel builders
        }
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
        echo "Mergin branches..."
      }
    }
  }
  post {
    always {
      cleanWs notFailBuild: true
    }
    success {
      // slackNotification('SUCCESSFUL', 'msales', 'optimizer-ui', env.BRANCH_NAME, SLACK_WEBHOOK_URL)
      // notify deployment slack channel
      // slackNotification('SUCCESSFUL', 'msales', 'optimizer-ui', env.BRANCH_NAME, "https://hooks.slack.com/services/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")
      script {
        jiraVersion(GIT_TAG, JIRA_PROJECT, "OUI", "released")
      }
    }
  }
}


