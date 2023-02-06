pipeline{
    agent any 
    environment{
        VERSION = "${env.BUILD_ID}"
    }
    stages{
        stage("sonar quality check"){
            agent {
                docker {
                    image 'openjdk:11'
                }
            }
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar-token') {
                            sh 'chmod +x gradlew'
                            sh './gradlew sonarqube'
                    }

                    timeout(time: 1, unit: 'HOURS') {
                      def qg = waitForQualityGate()
                      if (qg.status != 'OK') {
                           error "Pipeline aborted due to quality gate failure: ${qg.status}"
                      }
                    }

                }  
            }
        }

    stage("docker build & docker push"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker_pass', variable: 'docker_password')]) {
                             sh '''
                                docker build -t nexus-rm-nexus-repository-manager.nexus.svc.cluster.local:9200/springapp:${VERSION} .
                                docker login -u admin -p $docker_password nexus-rm-nexus-repository-manager.nexus.svc.cluster.local:9200
                                docker push  nexus-rm-nexus-repository-manager.nexus.svc.cluster.local:9200/springapp:${VERSION}
                               nexus-rm-nexus-repository-manager.nexus.svc.cluster.local:9200/springapp:${VERSION}
                            '''
                    }
                }
            }
        }
    }
}