pipeline {
	agent any
	tools {
		nodejs "npm"
	}
	stages {
		stage('Git Checkout'){
			steps {
				checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/haizensama/NodeJsTodoApp.git']])
			}
		}
		
		stage('Install Dependencies') {
			steps {
				sh 'npm install'
			}
		}
		
//		stage('Run Tests') {
//			steps {
//				sh 'npm test'
//			}
//		}

	}

}
