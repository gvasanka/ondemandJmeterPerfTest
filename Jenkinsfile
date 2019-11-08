
pipeline {
    agent {
           docker {
                  image 'gvasanka/cidockerimage'
                  args '-v /Users/asankav/.m2:/root/.m2 -v /Users/asankav/.kube:/root/.kube -v /Users/asankav/.helm:/root/.helm'
            }
    }

    environment {
            JOBNAME = ${JOB-NAME}
            jenkinsSlaveNodes = "Didn't found slave IPs"
    }

    parameters {
            string(defaultValue: "How many slave required?", description: '', name: 'noOfSlaveNodes')
    }

    stages {
            stage('Deploy JMeter Slaves') {
                   steps {
                          sh 'echo ======================================'
                          sh 'helm install --set server.replicaCount=${noOfSlaveNodes},master.replicaCount=0 --name distributed-jmeter-${JOBNAME}-${BUILD_NUMBER} stable/distributed-jmeter'
                          sh 'sleep 5'
                          sh 'echo ======================================'
                          }
            }
            stage('Search Slave IP details') {
                    steps {
                        script{
                              print "======================================"
                              print "Searching for Jmeter Slave IPs"
                              env.jenkinsSlaveNodes = sh(returnStdout: true, script:'kubectl get pods -l app.kubernetes.io/instance=distributed-jmeter-${JOBNAME}-${BUILD_NUMBER} -o jsonpath=\'{.items[*].status.podIP}\' | tr \' \' \',\'')
                              println("IP Details: ${env.jenkinsSlaveNodes}")
                              print "======================================"
                        }
                    }
             }
             stage('Execute Performance Test') {
                steps {
                    sh 'echo ${jenkinsSlaveNodes}'
                    sh 'echo ${HATest}'
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
            stage('Erase JMeter Slaves') {
                      steps {
                             sh 'echo ======================================'
                             sh 'helm delete distributed-jmeter-${JOBNAME}-${BUILD_NUMBER}'
                             sh 'sleep 5'
                             sh 'echo ======================================'
                             }
            }
    }
}