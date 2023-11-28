pipeline {
    agent any
    stages{
        stage('Get Credential Tokens'){
            steps {
                script {
                    git branch: 'main', credentialsId: 'e3d747ef-1364-469d-aaa9-c83db13d51f6', url: 'https://github.com/sergiodimier/integracion-continua.git'
                    echo 'abajo clone'
                    sh 'docker restart portainer'
                    echo 'finish'
                }
            }
        }
    }
}
