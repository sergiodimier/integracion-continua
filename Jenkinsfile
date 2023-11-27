pipeline {
    agent any
    stages{
        stage('Get Credential Tokens'){
            steps {
                script {
                    withCredentials(
                        [usernamePassword(
                            credentialsId: 'Portainer',
                            usernameVariable: 'PORTAINER_USERNAME',
                            passwordVariable: 'PORTAINER_PASSWORD',
                        )]    
                    )
                    {
                        def json="""
                            {"Username": "$PORTAINER_USERNAME", "Password": "$PORTAINER_PASSWORD"}
                        """
                        def jwtResponse = httpRequest acceptType: 'APPLICATION_JSON', 
                        contentType: 'APPLICATION_JSON', validResponseCodes: '200', httpMode: 'POST', 
                        ignoreSslErrors: true, consoleLogResponseBody: true, requestBody: json, url: "http://192.168.0.245:9443/api/auth"
                        def jwtObject = new groovy.json.JsonSlurper().parseText(jwtResponse.getContent())
                        env.JWTTOKEN = "Bearer ${jwtObject.jwt}"

                    }
                }
            }
        }
        stage('Build Docker Image on Portainer') {
            steps {
                script {
                  withCredentials([usernamePassword(credentialsId: 'e3d747ef-1364-469d-aaa9-c83db13d51f6', usernameVariable: 'BB_USERNAME', passwordVariable: 'BB_PASSWORD')]) {
                      def repoURL = """
                        http://192.168.0.245:9443/api/endpoints/1/docker/build?t=ing:ingenio&remote=https://github.com/$BB_USERNAME:$BB_PASSWORD/integracion-continua.git&dockerfile=Dockerfile
                      """
                      def imageResponse = httpRequest httpMode: 'POST', ignoreSslErrors: true, url: repoURL, validResponseCodes: '200', customHeaders:[[name:"Authorization", value: env.JWTTOKEN ]]
                  }
                }
            }
        }
        stage('Delete old Stack') {
            steps {
                script {
                  String existingStackId = ""
                  if("true") {
                    def stackResponse = httpRequest httpMode: 'GET', ignoreSslErrors: true, url: "http://192.168.0.245:9443/api/stacks", validResponseCodes: '200', consoleLogResponseBody: true, customHeaders:[[name:"Authorization", value: env.JWTTOKEN ], [name: "cache-control", value: "no-cache"]]
                    def stacks = new groovy.json.JsonSlurper().parseText(stackResponse.getContent())
                    stacks.each { stack ->
                      if(stack.Name == "ingenio") {
                        existingStackId = stack.Id
                      }
                    }
                  }
        
                  if(existingStackId?.trim()) {
                    // Delete the stack
                    def stackURL = """
                      http://192.168.0.245:9443/api/stacks/$existingStackId?endpointId=1
                    """
                    httpRequest acceptType: 'APPLICATION_JSON', validResponseCodes: '204', httpMode: 'DELETE', ignoreSslErrors: true, url: stackURL, customHeaders:[[name:"Authorization", value: env.JWTTOKEN ], [name: "cache-control", value: "no-cache"]]
                    sleep(5) // Le damos tiempo al borrado antes del proximo paso
                  }
        
                }
            }
        }
        stage('Deploy new stack to Portainer') {
            steps {
                script {
                  
                  def createStackJson = ""
                  // Stack does not exist
                  // Generate JSON for when the stack is created
                  withCredentials([usernamePassword(credentialsId: 'e3d747ef-1364-469d-aaa9-c83db13d51f6', usernameVariable: 'BB_USERNAME', passwordVariable: 'BB_PASSWORD')]) {
                    def swarmResponse = httpRequest acceptType: 'APPLICATION_JSON', validResponseCodes: '200', httpMode: 'GET', ignoreSslErrors: true, consoleLogResponseBody: true, url: "http://192.168.0.245:9443/api/endpoints/1/docker/swarm", customHeaders:[[name:"Authorization", value: env.JWTTOKEN ], [name: "cache-control", value: "no-cache"]]
                    def swarmInfo = new groovy.json.JsonSlurper().parseText(swarmResponse.getContent())
        
                    createStackJson = """
                      {"Name": "ingenio", "SwarmID": "$swarmInfo.ID", "RepositoryURL": "https://github.com/$BB_USERNAME/integracion-continua", "RepositoryReferenceName": "refs/heads/master", "ComposeFile": "docker-compose.yml", "RepositoryAuthentication": true, "RepositoryUsername": "$BB_USERNAME", "RepositoryPassword": "$BB_PASSWORD"}
                    """
        
                  }
        
                  if(createStackJson?.trim()) {
                    httpRequest acceptType: 'APPLICATION_JSON', contentType: 'APPLICATION_JSON', validResponseCodes: '200', httpMode: 'POST', ignoreSslErrors: true, consoleLogResponseBody: true, requestBody: createStackJson, url: "http://192.168.0.245:9443/api/stacks?method=repository&type=1&endpointId=1", customHeaders:[[name:"Authorization", value: env.JWTTOKEN ], [name: "cache-control", value: "no-cache"]]
                  }
        
                }
            }
        }
    }
}
