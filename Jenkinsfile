pipeline {
    agent any
    tools{
        maven "MAVEN3"
        jdk "OracleJDK8"
    }
    stages{
        stage('Fetch Code'){
            steps{
                git branch: 'main', url: 'https://github.com/sinhhuy1309/finalCICDLab.git'
            }
        }

        stage('Build'){
            steps{
                sh 'mvn install'
            }
            post{
                success{
                    echo 'Now Archiving it ...'
                    archiveArtifacts artifacts: '**/webapp/target/*.war'
                }
            }
        }
        
        // stage('Test'){
        //     steps{
        //         sh 'mvn test'
        //     }
        // }

        stage('Upload Artifacts'){
            steps{
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: '10.0.100.91:8081',
                    groupId: 'QA',
                    version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                    repository: 'regapp-repo',
                    credentialsId: 'nexuslogin',
                    artifacts: [
                    [artifactId: 'webapp',
                    classifier: '',
                    file: 'webapp/target/webapp.war',
                    type: 'war']
                    ]
                )
            }
        }

        stage('SSH Server'){
            steps{
                sshPublisher(publishers: [sshPublisherDesc(configName: 'ansible-server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '''ansible-playbook /opt/docker/regapp.yml;
                sleep 10;
                ansible-playbook /opt/docker/deploy_regapp.yml''', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '//opt//docker', remoteDirectorySDF: false, removePrefix: 'webapp/target', sourceFiles: 'webapp/target/*.war')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
            }
        }
    }
}