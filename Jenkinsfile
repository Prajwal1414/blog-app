@Library('Shared') _
pipeline{
  agent any

  environment{
    SONAR_HOME = tool "Sonar"
  }

  parameters{
    string(name: "FRONTEND_DOCKER_TAG", defaultValue: '', description: "Setting frontend docker image tag")
    string(name: "BACKEND_DOCKER_TAG", defaultValue: '', description: "Setting backend docker image tag")
  }

  stages{
    stage("Validate parameters"){
      steps{
        script{
          if(params.FRONTEND_DOCKER_TAG == '' || params.BACKEND_DOCKER_TAG == ''){
            error("FRONTEND_DOCKER_TAG and BACKEND_DOCKER_TAG must be provided")
          }
        } 
      }
    }

    stage("Workspace cleanup"){
      steps{
        script{
          cleanWs()
        }
      }
    }

    stage("Git: Code checkout"){
      steps{
        script{
          code_checkout("https://github.com/Prajwal1414/blog-app.git", "main")
        }
      }
    }

    stage("Trivy: Filesystem scan"){
      steps{
        script{
          trivy_scan()
        }
      }
    }

    stage("OWASP: Dependency check"){
      steps{
        script{
          owasp_dependency()
        }
      }
    }

    stage("SonarQube: Code analysis"){
      steps{
        script{
          sonarqube_analysis("Sonar", "wanderlust", "wanderlust")
        }
      }
    }

    stage("SonarQube: Code quality gate"){
      steps{
        script{
          sonarqube_code_quality()
        }
      }
    }

    stage("Exporting env varialbes"){
      parallel{
        stage("Backend env setup"){
          steps{
            script{
              dir("Automations"){
                sh "bash updatebackendnew.sh"
              }
            }
          }
        }

        stage("Frontend env setup"){
          steps{
            script{
              dir("Automations"){
                sh "bash updatefrontendnew.sh"
              }
            }
          }
        }
      }
    }

    stage("Docker: Build images"){
      steps{
        script{
          dir("backend"){
            docker_build("backend", "${params.BACKEND_DOCKER_TAG}", "prajwalkumar1453")
          }

          dir("frontend"){
            docker_build("frontend", "${params.FRONTEND_DOCKER_TAG}", "prajwalkumar1453")
          }
        }
      }
    }

    stage("Docker: Push to DockerHub"){
      steps{
        script{
          docker_push("frontend", "${params.FRONTEND_DOCKER_TAG}", prajwalkumar1453)
          docker_build("backend", "${params.BACKEND_DOCKER_TAG}", prajwalkumar1453)
        }
      }
    }
  }

  post{
    success{
      archiveArtifacts artifcats: '*.xml', followSymlinks: false
      build job: "Wanderlust-CD", parameters: [
        string(name: 'FRONTEND_DOCKER_TAG', value: "${params.FRONTEND_DOCKER_TAG}"),
        string(name: 'BACKEND_DOCKER_TAG', value: "${params.BACKEND_DOCKER_TAG}")
      ]
    }
  }
  
}
