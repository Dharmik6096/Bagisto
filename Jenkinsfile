@Library('shared') _

pipeline {
    agent any

    stages {

        stage('Clone Repo') {
            steps {
                script {
                    cloneRepo("https://github.com/Dharmik6096/Bagisto.git","main")
                }
            }
        }

        stage('Build Containers') {
            steps {
                script {
                    buildContainer()
                }
            }
        }

        stage('Run Containers') {
            steps {
              script {
                  runContainer()
              }
            }
        }

        stage('Verify Running') {
            steps {
               script{
                   verifyContainer()
               }
            }
        }
        
        stage('Deploy'){
            steps{
               script{
                   pushContainer("bagisto",
                   "bagisto-app:latest",
                   "bagisto-app",
                   "01")
               }
          }
     }
  }
}
