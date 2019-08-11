gitRepoUrl           = 'https://github.com/jijeesh/DevOps-kubernetes-full-stack.git'


node() {
  ansiColor('xterm') {

        stage('Checkout code') {
            checkout([$class: 'GitSCM',
                branches: scm.branches,
                doGenerateSubmoduleConfigurations: false,
                extensions: [[$class: 'LocalBranch'], [$class: 'CleanCheckout']],
                submoduleCfg: [],
                userRemoteConfigs: [[credentialsId: 'pipeline-readonly', url: "${gitRepoUrl}"]]
            ])
        }





        stage('Deploy to k8s cluster') {
            def branchName = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()

            tiller_namespace = branchName == 'master' ? 'dev' : 'staging'

            def credentialsId = "${tiller_namespace}-kubeconfig"

            withCredentials([[$class: "FileBinding", credentialsId: "${credentialsId}", variable: 'KUBECONFIG']]) {
                withEnv(["KUBECONFIG=${KUBECONFIG}", "TILLER_NAMESPACE=${tiller_namespace}", "PATH=$PATH:${helm_home}:${kubectl_home}"])  {

                    try {
                        if (branchName == "master") {
                            sh """
                                helm upgrade --install --namespace development myapp ./myapp-istio
                            """
                        }

                        currentBuild.result = 'SUCCESS'

                    } catch (Exception err) {
                        currentBuild.result = 'FAILURE'
                    }

                }
            }
        }
    }
}
