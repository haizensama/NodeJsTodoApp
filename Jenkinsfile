pipeline {
	agent any
	tools {
		nodejs "npm"
	}
	environment {
		DOCKER_HUB_CREDENTIALS_ID = 'jen-dockerhub'
		DOCKER_HUB_REPO = 'haizen12/nodejstodoapp'
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
		stage('Build Docker Image'){
			steps {
				script {
					dockerImage = docker.build("${DOCKER_HUB_REPO}:latest")
				}
			}
		}
		stage('Push Image to DockerHub'){
			steps {
				script {
					docker.withRegistry('https://registry.hub.docker.com', "${DOCKER_HUB_CREDENTIALS_ID}"){
						dockerImage.push('latest')
					}
				}
			}
		}

	}

}
