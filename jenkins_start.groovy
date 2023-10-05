def img_tag = "esuat_start.app.1.0.$BUILD_NUMBER"
pipeline {
    agent any
    stages {

        stage('checkout') {
           steps {

                        checkout([$class: 'GitSCM', branches: [[name: '*/uat']], userRemoteConfigs: [[url: 'https://git-codecommit.ap-south-1.amazonaws.com/v1/repos/pp-earlysalary',credentialsId: '16264531-46f2-4def-8f9d-dcc63ca0551f']]])

            }
       }

        stage('Build') {
            steps {
               sh 'sudo -S docker build -t pp-earlysalary-uat .'
            }
        }

        stage('ECR push') {
            steps {

               sh 'aws ecr get-login-password --region ap-south-1 --profile UAT | sudo docker login --username AWS --password-stdin 016900471114.dkr.ecr.ap-south-1.amazonaws.com'
               sh "sudo docker tag pp-earlysalary-uat:latest 016900471114.dkr.ecr.ap-south-1.amazonaws.com/lvpartner:${img_tag}"
               sh "sudo docker push 016900471114.dkr.ecr.ap-south-1.amazonaws.com/lvpartner:${img_tag}"
            }
        }

        stage('deploy') {
             steps {
                        checkout([$class: 'GitSCM', branches: [[name: '*/earlysalaryuat']], userRemoteConfigs: [[credentialsId: 'fac7fd7b-e8a4-406f-bb6e-44fd8ee321b9', url: 'https://git-codecommit.ap-south-1.amazonaws.com/v1/repos/hvpartners']]])
                        sh "sudo echo ${img_tag} > app-tag.txt"
                        sh "sudo sh app.sh"
                        //sh "export AWS_PROFILE=default"
                        sh "aws eks update-kubeconfig --name UAT-CP-EKS --region ap-south-1 --profile UAT"
                        sh "helm upgrade --install earlysalaryuat earlysalaryuat -n hvpartners"
                    }
        }
        stage("wait for deployment"){
            steps {
                sleep time: 180, unit: 'SECONDS'
            }
        }


        stage("Deployment Status"){
            steps {
                    sh "aws eks update-kubeconfig --name UAT-CP-EKS --region ap-south-1 --profile UAT"
                    sh "kubectl get pods -n hvpartners"
            }
        }

    }
}