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
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                    chmod +x kubectl
                    mv kubectl /usr/local/bin/kubectl
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    kubeconfig(caCertificate: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCakNDQWU2Z0F3SUJBZ0lCQVRBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwdGFXNXAKYTNWaVpVTkJNQjRYRFRJMU1ERXdOekV5TWpFeE1sb1hEVE0xTURFd05qRXlNakV4TWxvd0ZURVRNQkVHQTFVRQpBeE1LYldsdWFXdDFZbVZEUVRDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTFhoCjBVSkNmU3oxbUNacUNMQTlEdlUxVWtCQnI5SG5lVFl2NlpKcmVLMUpmNlNkakh1NFgzOExjRXkyd2F2bnFZS0UKZWtsVC9SN2wyWnh5aWZIcFkwVm1UM3ptK3k5L2VkRXJMWkFPME8xUnoyNzcyVnhmTndtWklPR3paSlFZcVhDNAo1Ym9MOTdrV3FFUWRLZHlLUGxQSFZVQ2swaEJUR2hieHN1QUdSc2lWVGNsREJ4QnloSUwzeGNLVGVRdHBoRjBMClJFNERTZ2JVdnFFRXJQVzJEOUVGdXdtbnIzYnoyUTZVQXBjQm9UN1g5Wk42eUlLZUFTc1hJdFBRN1ZxcFVEVjYKeGJ0cXBEL1drREJiRXBwQ1V6T1hjSGZYcGVrQ25UTkJXVFlTWGVGRnRnOVBxaW5tZEtEWmp3QTV1V2l2cjA3ZQo0azF6aXhyS1pBWUNBOVdoNDIwQ0F3RUFBYU5oTUY4d0RnWURWUjBQQVFIL0JBUURBZ0trTUIwR0ExVWRKUVFXCk1CUUdDQ3NHQVFVRkJ3TUNCZ2dyQmdFRkJRY0RBVEFQQmdOVkhSTUJBZjhFQlRBREFRSC9NQjBHQTFVZERnUVcKQkJUQmMrcU9scktndWNCQjIveTAvR1VCSXVRMTREQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUFTbG9IaUxKTgpzTWxtUS9wakUrMmNlMmdCT09Wb1VBMUlyRmp1MWpKL2o4NXBRM1ljcDhIcGhxUHlSTmNId0FaVCt0L1k0TkxNCkxncUxpdHV5aWxmVVErWkM2VTN0RzBmQWhNZkE4dFJwQ2dqT0E2UmZsUWxFd3Z1b3cyN0dpbWpQUlExcEhIc0kKQlAyZ21jQ2lFVDVOZG9SRGZpb3RzelJXcUhsOERyeEZVR0F6dHB1QTlBRENBM0hrUWM4ZUJLMmh0ckhEbWRNTQpGNGJwT3NXbmFxNm5peUFlUEMzS0FFV05mOWp1RmMwc01lZUVFNXRXdllJNUd2VzNZaW1mNmIyUU9YR1pVOXJkClZUaWFtb1dHeHpYZG5oVmtFT3czbXY3TmNQbktrb2tjVVhBOXZ3cjRwdVFHalA0T2pxNUdRQ2lKT2xScmk4TCsKaDVJMVJXRWk4SzBkM2c9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg', clusterName: '', contextName: '', credentialsId: 'kubeconfig', namespace: '', restrictKubeConfigAccess: false, serverUrl: 'https://kubernetes.docker.internal:6443') {
                        sh 'kubectl apply -f deployment.yaml'
                    }
                }
            }
        }
    }
}
