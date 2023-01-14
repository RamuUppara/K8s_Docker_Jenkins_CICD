pipeline {
    agent any

//tools {
  //terraform 'Terraform_v1.2.7'
  //}
environment {
  ACCESS_KEY = credentials('access-key')
  SECRET_KEY = credentials('secret-key')
}

stages{
    stage ('git checkout') {
      steps{
        git url: 'https://github.com/DeepakshiPurushotham/Task_2.git' , branch: 'main'
        }
      }
     
    stage ('Terraform_init') {
      steps {
        sh "terraform init"
           }
         }
        
     stage ('Terraform_Apply/Destroy') {
        steps {
    
         sh "terraform ${action} -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' --auto-approve" 
            }
         }
       }
}