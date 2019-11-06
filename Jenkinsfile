pipeline {
        agent {
                         docker {
                             image 'gvasanka/cidockerimage'
                             args '-v /Users/asankav/.m2:/root/.m2 -v /Users/asankav/.kube:/root/.kube -v /Users/asankav/.helm:/root/.helm'
                         }
                     }
    stages {
            stage('Deploy JMeter Slaves') {
                   steps {
                          sh 'echo ======================================'
                          sh 'helm install --name distributed-jmeter-${BUILD_NUMBER} stable/distributed-jmeter'
                          sh 'sleep 5'
                          sh 'echo ======================================'
                          }
            }
            stage('Get JMeter Slave IP details') {
                    steps {
                        script{
                                    print "======================================"
                                    print "Searching for Jmeter Slave IPs"
                                    env.jenkinsSlaveNodes = sh(returnStdout: true, script:'kubectl get pods -l app.kubernetes.io/component=server -o jsonpath=\'{.items[*].status.podIP}\' | tr \' \' \',\'')
                                    println("IP Details: ${env.jenkinsSlaveNodes}")
                                    print "======================================"

                                }
                        }
             }
             stage('Build') {
                steps {
                    sh 'echo ${jenkinsSlaveNodes}'
                    sh 'mvn clean install \"-DjenkinsSlaveNodes=${jenkinsSlaveNodes}\"'
                }
                post{
                     always{
                            dir("target/jmeter/results/"){
                                 sh 'pwd'
                                 perfReport 'httpCounterDocker.csv'
                                }
                            }
                      }
            }
            stage('UnDeploy JMeter Slaves') {
                      steps {
                             sh 'echo ======================================'
                             sh 'helm delete distributed-jmeter-${BUILD_NUMBER}'
                             sh 'sleep 5'
                             sh 'echo ======================================'
                             }
            }
    }
}