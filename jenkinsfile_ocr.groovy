def img_tag = "feapplatest"
pipeline {
    agent any
    stages {

        stage('checkout') {
           steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/UAT']], userRemoteConfigs: [[url: 'https://git-codecommit.ap-south-1.amazonaws.com/v1/repos/OPA_Repository',credentialsId: '6565a51f-dd94-444e-a115-3d42b4a928dd']]])
            }
       }

        stage('Build') {
            steps {
               sh 'sudo -S docker build -t feappuat .'
            }
        }

        stage('ECR push') {
            steps {

              // sh 'aws ecr get-login-password --region ap-south-1 | sudo docker login --username AWS --password-stdin 535579722445.dkr.ecr.ap-south-1.amazonaws.com'
               //sh "sudo docker tag pp-stashfin-prod:latest 535579722445.dkr.ecr.ap-south-1.amazonaws.com/pp-stashfin-prod:${img_tag}"
               sh "sudo docker login --username 'bm2nhaouvzhw/svcokeappadm' --password '(6j0Hjb0;UO6>r#[{<9U' bom.ocir.io"
               sh "sudo docker push bom.ocir.io/bm2nhaouvzhw/bre_uat:${img_tag}"
            }
        }

       // stage('deploy') {
         //    steps {
        //                checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[credentialsId: 'fac7fd7b-e8a4-406f-bb6e-44fd8ee321b9', url: 'https://git-codecommit.ap-south-1.amazonaws.com/v1/repos/helm-new']]])
          //              sh "sudo echo ${img_tag} > app-tag.txt"
            //            sh "sudo sh app.sh"
              //          sh "export AWS_PROFILE=default"
                //        sh "aws eks update-kubeconfig --name ekscibil --region ap-south-1"
                  //      sh "helm upgrade --install ekscibil ekscibil -n eksrcuvendor"
                //    }
        //}

    }
}