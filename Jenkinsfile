pipeline {
//     agent any
        agent {
                         docker {
                             image 'gvasanka/cidockerimage'
                             args '-v /Users/asankav/.m2:/root/.m2 -v /Users/asankav/.kube:/root/.kube -v /Users/asankav/.helm:/root/.helm'
                         }
                     }
    stages {
            stage('Jmeter Slave Stage') {
//                     agent {
//                             docker {
//                                 image 'alpine/helm:2.14.0'
//                                 args '-v /Users/asankav/.kube:/root/.kube -v /Users/asankav/.helm:/root/.helm'
//                             }
//                      }
                    steps {
                        sh 'pwd'
                        sh 'echo ${JenkinsTestParam}'
                        sh 'sleep 10m'
                        sh 'export SERVER_IPS=$(kubectl get pods -l app.kubernetes.io/component=server -o jsonpath=\'{.items[*].status.podIP}\' | tr \' \' \',\')'
                        sh 'echo ${SERVER_IPS}'
//                         sh 'helm version'
                    }
             }
//              stage('Deploy JMeter Slave') {
//                 container('helm') {
//                        sh 'pwd'
//                        sh 'helm upgrade --install --force jobrm-static ./charts/jobrm-static --set image.repository=jobrm --set image.tag=latest --set service.type=NodePort --set service.nodePort=31001'
//                      }
//                      steps {
//                          sh 'pwd'
//              //                         sh 'docker run -ti --rm -v $(pwd):/apps -v ~/.kube:/root/.kube -v ~/.helm:/root/.helm alpine/helm:2.14.3 install --name my-release5 stable/jenkins'
//                                  }
//               }

             stage('Build') {
//                 agent {
//                      docker {
//                          image 'maven:3-alpine'
//                          args '-v /Users/asankav/.m2:/root/.m2'
//                      }
//                  }
                steps {
                    sh 'mvn clean install \"-DjenkinsSlaveNodes=${jenkinsSlaveNodes}\"'
                }
                post{
                     always{
                            dir("target/jmeter/results/"){
                                sh 'pwd'
                                //sh 'mv *httpCounterDocker.csv httpCounterDocker.csv '
                                 perfReport 'httpCounterDocker.csv'
                                }
                            }
                      }
            }
    }
}