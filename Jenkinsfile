pipeline {
    agent any
    stages{
        stage('Test'){
            steps {
                sh 'cd /mnt && sudo git clone https://github.com/sergiodimier/integracion-continua.git'
            }
        }
    }
}
