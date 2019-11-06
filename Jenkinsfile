pipeline {
//     agent any
        agent {
                         docker {
                             image 'gvasanka/cidockerimage'
                             args '-v /Users/asankav/.m2:/root/.m2 -v /Users/asankav/.kube:/root/.kube -v /Users/asankav/.helm:/root/.helm'
                         }
                     }
    stages {
            stage('Get JMeter Slave IP details') {
                    steps {
                        script{
                                    print "======================================"
                                    print "Searching for Jmeter Slave IPs"
                                    def SERVER_IPS = '$(kubectl get pods -l app.kubernetes.io/component=server -o jsonpath=\'{.items[*].status.podIP}\' | tr \' \' \',\')'
                                    print "======================================"

                                }
    //                         sh 'pwd'
    //                         sh 'echo ${JenkinsTestParam}'
    //                         sh 'echo ${jenkinsSlaveNodes}'
    // //                         sh 'sleep 10m'
    //                         def SERVER_IPS = sh '$(kubectl get pods -l app.kubernetes.io/component=server -o jsonpath=\'{.items[*].status.podIP}\' | tr \' \' \',\')'
    //                         sh 'echo ${SERVER_IPS}'
    //                         sh 'helm version'
    //                         sh 'helm list'
    //                         sh 'kubectl get pods'
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
                steps {
                    sh 'echo ${SERVER_IPS}'
                    sh 'mvn clean install \"-DjenkinsSlaveNodes=${SERVER_IPS}\"'
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