pipeline {
    agent any
    stages{
        stage('Test'){
            steps {
                sh 'cd /mnt/integracion-continua && git pull'
            }
        }
    }
}
