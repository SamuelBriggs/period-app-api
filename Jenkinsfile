pipeline {
    agent any
   
    environment {
        DOCKERHUB_USERNAME = credentials('dockerID')
        DOCKERHUB_PASSWORD = credentials('dockerID')
        EC2_PRIVATE_KEY = credentials('EC2_PRIVATE_KEY')
        EC2_PUBLIC_IP = 'ec2-3-253-141-89.eu-west-1.compute.amazonaws.com'
        EC2_USERNAME = 'ec2-user'
    }
   
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    def imageName = 'periodapp'
                    def imageTag = 'latest'
                    def dockerImage = "${imageName}:${imageTag}"
                   
                    sh docker build -t ${dockerImage} .
                }
            }
        }
       
        stage('Push Docker Image to DockerHub') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerID', url: '') {
                        def dockerImage = "${DOCKERHUB_USERNAME}/${imageName}:${imageTag}"
                       
                        sh "docker tag ${imageName}:${imageTag} ${dockerImage}"
                        sh "docker login -u ${DOCKERHUB_USERNAME} -p ${DOCKERHUB_PASSWORD}"
                        sh "docker push ${dockerImage}"
                    }
                }
            }
        }
       
        stage('SSH to EC2 and Run Docker Container') {
            steps {
                script {
                    def privateKey = EC2_PRIVATE_KEY
                    def sshCommand = "ssh -i %privateKey% -o StrictHostKeyChecking=no ${EC2_USERNAME}@${EC2_PUBLIC_IP}"
                   
                    sh "${sshCommand} 'docker pull ${dockerImage}'"
                    sh "${sshCommand} 'docker run -d -p 80:80 ${dockerImage}'"
                }
            }
        }
    }
   
    post {
        always {
            cleanWs()
        }
    }
}
