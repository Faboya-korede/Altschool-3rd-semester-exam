pipeline {
    agent any
    
    environment {
        access-key  = credentials('access-key')
        secret-key = credentials('secret-key')
    }
    
    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -var "access_key=${AWS_ACCESS_KEY_ID}" -var "secret_key=${AWS_SECRET_ACCESS_KEY}"'
            }
        }
        stage('Terraform Apply') {
            when {
                expression {
                    // This expression will only trigger the stage if the branch name starts with "deploy/"
                    return env.BRANCH_NAME.startsWith('deploy/')
                }
            }
            steps {
                sh 'terraform apply -var "access_key=${AWS_ACCESS_KEY_ID}" -var "secret_key=${AWS_SECRET_ACCESS_KEY}" -auto-approve'
            }
        }
    }
}
