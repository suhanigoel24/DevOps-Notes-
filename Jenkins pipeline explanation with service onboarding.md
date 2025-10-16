
```
currentBuild.displayName= "#"+currentBuild.number+" ${params.service} "

pipeline {

agent any

environment {

JAVA_HOME='/opt/java/java17'

mvn_home= '/opt/apache-maven/bin/mvn'

namespace = 'staging'

app_name = 'cst-pi-endpoint-service-staging'

release_version = sh(script: 'date +%Y%m%d', , returnStdout: true).trim()

release = sh(script: 'if [ "$action" == "Deploy" ];then echo $image; elif [ "$git" == "tag" ];then echo `head /dev/urandom | tr -dc a-z0-9 | head -c 8 ; echo `-`date +%Y%m%d`-${BUILD_NUMBER}; else echo "$service-dev-$value";fi', , returnStdout: true).trim()

BRANCH = sh(script: 'if [ -z "$value" ]; then echo $image; else echo $value;fi', , returnStdout: true).trim()

service_name = 'cst-pi-endpoint-service-staging'

}

stages {

stage("Checkout") {

when {

expression { params.action == 'Build' || params.action == 'Build and Deploy'}

}

steps {

  

script {

if (params.git == "branch") {

echo "checkout branch"

checkout poll: false, scm: [$class: 'GitSCM', branches: [[name: '*/${value}']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: '/var/lib/jenkins/workspace/service-process-workspace/$service/$env']], submoduleCfg: [], userRemoteConfigs: [[url: 'git@bitbucket.org:paytmteam/pi_endpoint_service.git']]]

  

}

if (params.git == "tag") {

echo "checkout tag"

checkout poll: false, scm: [$class: 'GitSCM', branches: [[name: 'refs/tags/${value}']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: '/var/lib/jenkins/workspace/service-process-workspace/$service/$env']], submoduleCfg: [], userRemoteConfigs: [[url: 'git@bitbucket.org:paytmteam/pi_endpoint_service.git']]]

  

}

  

}

}

}

stage('Build') {

when {

expression { params.action == 'Build' || params.action == 'Build and Deploy'}

}

steps {

sh '''

set +e

cd ${JENKINS_HOME}/workspace/service-process-workspace/$service/$env

export JAVA_HOME=/opt/java/java17

export PATH=$JAVA_HOME/bin:$PATH

gradle wrapper --gradle-version 8.10

./gradlew clean build

aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 337891198417.dkr.ecr.ap-south-1.amazonaws.com

docker buildx build -f Dockerfile -t 337891198417.dkr.ecr.ap-south-1.amazonaws.com/cst-pi-endpoint-service-staging:${value}-${BUILD_NUMBER} --platform linux/amd64,linux/arm64 --push .

'''

}

}

stage('Deploy') {

when {

expression { params.action == 'Deploy' || params.action == 'Build and Deploy'}

}

steps {

sh '''

set +e

cd ${JENKINS_HOME}/workspace/single-pipeline-job-nonprod/services-v1/$service/$env

git config --global user.email "priyesh1.karn@paytm.com"

git config --global user.name "Priyesh"

git pull origin master

cat manifest.yaml | sed s~@@version@@~${value}-${BUILD_NUMBER}~g | sed s~@@app_name@@~${app_name}~g > ${JENKINS_HOME}/workspace/service-process-workspace/values/cstapp_${app_name}_values.yaml

cd ${JENKINS_HOME}/workspace/single-pipeline-job-nonprod/istio-proxy/

./istioctl kube-inject --injectConfigFile inject-config.yaml --meshConfigFile mesh-config.yaml --valuesFile inject-values.yaml -n ${namespace} --filename ${JENKINS_HOME}/workspace/service-process-workspace/values/cstapp_${app_name}_values.yaml > ${JENKINS_HOME}/workspace/single-pipeline-job-nonprod/manifests-nonprod/cstapp_istio_proxy_${app_name}_values.yaml

kubectl apply -f ${JENKINS_HOME}/workspace/single-pipeline-job-nonprod/manifests-nonprod/cstapp_istio_proxy_${app_name}_values.yaml '''

}

}

}

}
```

