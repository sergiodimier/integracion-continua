pipeline {
    agent any

    stages {
        stage('Update Repositories and Restart Docker') {
            steps {
                script {
                    // Navegar a la carpeta del repositorio
                    dir("/mnt/integracion-continua") {
                        // Realizar un git pull
                        sh 'git pull origin main'
                    }

                    // Reiniciar el contenedor Docker (ajusta el comando según tus necesidades)
                    sh 'docker restart portainer'
                }
            }
        }
    }

    options {
        buildDiscarder(logRotator(artifactDaysToKeepStr: '', daysToKeepStr: '', numToKeepStr: '10', artifactNumToKeepStr: '10'))
    }

    triggers {
        githubPush()
    }
}
