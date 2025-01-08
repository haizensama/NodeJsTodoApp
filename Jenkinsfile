pipeline {
    agent any
    tools {
        nodejs "npm"
    }
    environment {
        DOCKER_HUB_CREDENTIALS_ID = 'jen-dockerhub'
        DOCKER_HUB_REPO = 'haizen12/nodejstodoapp'
        KUBECONFIG = "${HOME}/.kube/config"
    }
    stages {
        stage('Git Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/haizensama/NodeJsTodoApp.git']])
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        // stage('Run Tests') {
        //     steps {
        //         sh 'npm test'
        //     }
        // }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_HUB_REPO}:latest")
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', "${DOCKER_HUB_CREDENTIALS_ID}") {
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Install Kubectl') {
            steps {
sh '''
            # Install kubectl
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            chmod +x kubectl
            mv kubectl $HOME/bin/kubectl

            # Install Minikube
            curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
            chmod +x minikube-linux-amd64
            mv minikube-linux-amd64 $HOME/bin/minikube

            # Ensure $HOME/bin is in the PATH
            echo "export PATH=$HOME/bin:$PATH" >> $HOME/.bashrc
            . $HOME/.bashrc

            # Run Minikube as the non-root user (jenkins user)
            if [ "$(id -u)" -eq 0 ]; then
                echo "Running Minikube as jenkins user"
                sudo -u jenkins minikube start --driver=docker
            else
                minikube start --driver=docker
            fi

            # Configure kubectl
            kubectl config set-cluster minikube --server=https://192.168.49.2:8443
            kubectl config use-context minikube
        '''

            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    kubeconfig(caCertificate: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJWkFUZk4vWmNuUUl3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TlRBeE1EWXhOakUxTlROYUZ3MHpOVEF4TURReE5qSXdOVE5hTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURRVEpKOW5nRXErdG9zQkNac0JKY2RnOWxDbFhSSkI5czlHdW9nTGJudDdtTjl4K1JZWCtxNlNscncKcitJQjVNUDF1eFY5U3pWOTVLdW5XUmNHQUdJNHNjM2szS09ITm4yYk9CUlR6V09wamx2RFFjYjJVZkF1ZGlYZgp2YUpyRUx6YjNUVUsrSndiOUszRG1Sekg2azIrb3p6SG1MODlLRkFKelZXN2dscm1SZW1BRHVKRENFeTQwNVpHCjZpSE5BalgvZHh4bE95MWlnbkFhaFFXMjRCZnhaY0pDdUFMMWJaNHNCQmgzc29zUWtnNnBCYVdOcEtWMEhYNHcKY2tHK0I4SERhLzRFVy9BQVlpNTJETGlmR3JKeGc2T2xQVy9DSnQxN3pwNm45cHpTaXV5c2ZvaGpIb1Yxa0tHWApLcmhNQTlBeWRXNlBsOW1wVmRTNEJCR0RxK2J4QWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJSVUNWeFgzdG1hWjJ0a1dXV1o5VE9wMkt2WUNUQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQTZ5cE9wNkRSWgpIT1BTSEJpZXNtQjdMUi9UQ3FWMGVqMFl4bnBqa0NxcXFJWk5DZjBiRHhCOGJKamUvSURTbjZFWjNzbzBrZCt2CnM3anY1TDhhdXl2ZGZHQmFTRTJmUUNxbGNPbExSU2FGSzEraDNmYWVOYmE2c1g3dnQrZFc3SlFVWGtrN2ZDR2kKc1Q5dWdhbm5jNThabk52YUE4RW5mSXl6ajViYTlCNUhGb0ZQSlJkQk5yZENKRCt1K0x0Z2RiMFZGdngwU2E0eQpoUElnWlBvRUs2YmtIaDNkYXAyRHA1NDJEN29NQUt5SUJlNFF1akRrTWt0U09kSExNN3RvcEFmMVlIVkV6aVQ3CnBVU1ZZVHdxdnRFZVJYQVdlZjJKdE01ZUhEcG9VWit2NzNDNlM1bE9CTkNVekh6STIzK3YyaDFzWVNiaDdwNjEKQnZHYmlteWRibFNkCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K', credentialsId: 'kubeconfignew', serverUrl: '192.168.49.2:8443 ') {
                        sh 'kubectl apply -f deployment.yaml'
                    }
                }
            }
        }
    }
}
