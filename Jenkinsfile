pipeline {
    agent any
    tools {
        nodejs "npm"
    }
    environment {
        DOCKER_HUB_CREDENTIALS_ID = 'jen-dockerhub'
        DOCKER_HUB_REPO = 'haizen12/nodejstodoapp'
        KUBECONFIG = credentials('kubeconfig')
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

        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }

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
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                    chmod +x kubectl
                    mv kubectl /usr/local/bin/kubectl
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                   kubeconfig(caCertificate: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCakNDQWU2Z0F3SUJBZ0lCQVRBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwdGFXNXAKYTNWaVpVTkJNQjRYRFRJMU1ERXdPVEl4TURFMU1Wb1hEVE0xTURFd09ESXhNREUxTVZvd0ZURVRNQkVHQTFVRQpBeE1LYldsdWFXdDFZbVZEUVRDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBT0xDCkN2SEZHVUpFZEYrTjBjUEtsb0p1VG96bmVSTlJmY1VPckloN1M1Ty82TGFteXRRbmJ4R1RaTGRwUnV0UExCU1IKVlhoVFV0RmVRWmZzZlAwT2ZoOUJ1emNXekttYmlsZi8wUE9yeGpiNXZRUjVqYjZyYldkeXl1OHFZRERwaFZkMQpYWVo0OTM3dG0xRDZlLzBaWjZHU3d4QVM4aWFzd2N3MGVxWjNHUHBWdkdPN1JXUWh4RXdtWDIxSy9MaGNvd1JtCjI2S1dubDBvZVY2V21aSThKQlhuQkxHb0UwNEdXMGZUSy9PMERqYmcvbTBYTlRJREtFM24rNldZS3dYcE5FK0UKeXl3R0UzbUk4Qm9EbEVHajhyc3FoNy8vMm5VSFo3ZkJZQ1ZxcmtlOGtXdlNsTXFUKzZ1WllVczFGU3pUeU83bwpuTEdLM3VNZEtySkx0b2ZpTFNzQ0F3RUFBYU5oTUY4d0RnWURWUjBQQVFIL0JBUURBZ0trTUIwR0ExVWRKUVFXCk1CUUdDQ3NHQVFVRkJ3TUNCZ2dyQmdFRkJRY0RBVEFQQmdOVkhSTUJBZjhFQlRBREFRSC9NQjBHQTFVZERnUVcKQkJTdW9ValVaTUxiZnBEMlE4YkNIai9FUnBuWnlqQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUF3ZURvWk83NgpyTHBFM1JzQ2xGMTBrejN3U3R0VlVncVVnVUxRLzhrQzZkendxU0FZMFllbTNVMXVxUXNCVUJMN0xkaDU5UVoxCmk2QWZRcGNJZmY3RGEwbWcwRURCVGhZWUFHck5FL2V0K3B6aE0yemwvZk1ZMnMza0tPQkdpbThCQjRvUERCT2gKMGp4QzRHeXlZMnZWNVYyU2hRSTE5Rmh6Rm5HeU1rRVV2SkZIeWJ5SXhBNnRNQ0tUa1VJcmVzaFdUeko5WUE2YQoxTkVMNE5wdVBpUXlvcWx5V3BWK01mb2l0a0VKQnd1eHUzam5INjZreHBReHg5eHNmSFRmMEhvZmFjY1NIOGpNCjZOU2VXenBCSDFTRG1odVNTaU1rb0oremlkYnRHM0YzdWNaeDIvWWQydnFqVEQ4emxuQU04cTdHOHZiTTVIMHEKaEdSTWxBVXhnV0pnTWc9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==', credentialsId: 'kubeconfig', serverUrl: 'https://192.168.49.2:8443') {
    sh 'kubectl apply -f deployment.yaml'
}
                    }
                }
            }
        }
    }
}
