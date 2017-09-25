pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        script {
          sh("git log ${git_tag_old}..HEAD --oneline | grep -Eo '([A-Z0-9]{3,}-)([0-9]+)' | sort -u > git_commits.log")
        }
        
        input(message: 'Deploy to STAGING ? ', id: 'deploy_stage ', ok: 'Yes')
      }
    }
    stage('JIRA') {
      steps {
        script {
          def git_log = readFile('git_commits.log')
          println git_log
          def jira_version = jiraVersion(git_tag, JIRA_PROJECT)
          jiraTicketsFromLog(git_log, jira_version)
        }
        
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