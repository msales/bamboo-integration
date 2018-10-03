@Library('msales-jenkins-unified-k8s-pipeline@dev') _

burzumIshi(
  [ "PROJECT" : "bamboo/bamboo" ,
    "K8S_NAMESPACE" : "bamboo",
    "K8S_DEPLOYMENT" : "bamboo",
    "DEPLOYMENT_PATTERN" : readYaml(text: """
Production:
  clusters:
    eu-central-1:
      namespaces:
        bamboo:
          types: pope of nope
  
""")
  ]
)

