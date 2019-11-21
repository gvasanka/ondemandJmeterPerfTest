
pipeline {
    agent {
//            docker {
//                   image 'gvasanka/cidockerimage'
//                   args '-v /Users/asankav/.m2:/root/.m2 -v /Users/asankav/.kube:/root/.kube -v /Users/asankav/.helm:/root/.helm'
//             }
            kubernetes {
                  yamlFile 'build-pod.yaml'  // path to the pod definition relative to the root of our project
                  defaultContainer 'maven'  // define a default container if more than a few stages use it, will default to jnlp container
             }
    }

    environment {
            JOBNAME = "jobname"
    }

    parameters {
            string(defaultValue: "1", description: 'How many slave required ?', name: 'noOfSlaveNodes')
    }

    stages {
            stage('Deploy JMeter Slaves') {
                   steps {
                        container('kubehelm'){
                              sh 'echo ======================================'
                              sh 'helm install distributed-jmeter-${JOBNAME}-${BUILD_NUMBER} stable/distributed-jmeter --set server.replicaCount=${noOfSlaveNodes},master.replicaCount=0'
                              sh 'sleep 5'
                              sh 'echo ======================================'
                        }
                    }
            }
            stage('Search Slave IP details') {
                    steps {
                        container('kubehelm'){
                            script{
                                  print "======================================"
                                  print "Searching for Jmeter Slave IPs"
                                  env.jenkinsSlaveNodes = sh(returnStdout: true, script:'kubectl get pods -l app.kubernetes.io/instance=distributed-jmeter-${JOBNAME}-${BUILD_NUMBER} -o jsonpath=\'{.items[*].status.podIP}\' | tr \' \' \',\'')
                                  println("IP Details: ${env.jenkinsSlaveNodes}")
                                  print "======================================"
                            }
                        }
                    }
             }
             stage('Execute Performance Test') {
                steps {
                    sh 'echo ======================================'
                    sh 'echo ${jenkinsSlaveNodes}'
                    sh 'mvn clean install \"-DjenkinsSlaveNodes=${jenkinsSlaveNodes}\"'
                    sh 'echo ======================================'
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
                            container('kubehelm'){
                                 sh 'echo ======================================'
                                 sh 'helm delete --purge distributed-jmeter-${JOBNAME}-${BUILD_NUMBER}'
                                 sh 'sleep 5'
                                 sh 'echo ======================================'
                            }
                      }
            }
    }
}