pipeline {
    agent {
//         docker {
//             image 'maven:3-alpine'
//             args '-v /root/.m2:/root/.m2'
//         }
    }
    stages {
        stage('Deploy JMeter Slave') {
                    steps {
                        sh 'pwd'
                        sh 'echo ${JenkinsTestParam}'
                        sh 'docker run -ti --rm -v $(pwd):/apps -v ~/.kube:/root/.kube -v ~/.helm:/root/.helm alpine/helm:2.14.3 install --name my-release5 stable/jenkins'
                    }
                }
        stage('Build') {
            steps {
                sh 'mvn clean install'
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