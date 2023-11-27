pipeline {
    agent any
    stages{
        stage('Test'){
            steps {
                sh 'cd /mnt'
                sh 'git clone https://github.com/sergiodimier/integracion-continua.git'
            }
        }
    }
}
