pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
            args '-v /root/.m2:/root/.m2'
        }
    }
    stages {
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