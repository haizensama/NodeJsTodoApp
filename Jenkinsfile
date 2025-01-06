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
		stage('Install Kubectl'){
			steps{
				sh '''
                                curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                		chmod +x kubectl
                		mv kubectl /usr/local/bin/kubectl
                                '''
			}
		}
		stage('Deploy to kubernetes'){
			steps {
				script {
					withKubeConfig(caCertificate: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJWkFUZk4vWmNuUUl3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TlRBeE1EWXhOakUxTlROYUZ3MHpOVEF4TURReE5qSXdOVE5hTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUUR
}

					}
				}
			}
		}

	}

}
