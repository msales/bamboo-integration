@Library('msales-jenkins-unified-k8s-pipeline@dev') _

simplePipeline(
  [ "PROJECT" : "bamboo/bamboo" ,
    "K8S_NAMESPACE" : "bamboo",
    "K8S_DEPLOYMENT" : "bamboo",
    "USED_ENVIRONMENTS" : [ ["name" : "Production", "clusters" : ["eu-central-1" , "us-east-1"] ] ] 
  ]
)

