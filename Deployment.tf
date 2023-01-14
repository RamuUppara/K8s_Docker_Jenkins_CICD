/*data "aws_eks_cluster" "test" {
  name = "demo"
}*/



resource "null_resource" "command" {
  #depends_on = [aws_eks_node_group.public-nodes]
  triggers = {
    content = "${aws_eks_node_group.public-nodes.id}"
    }
  provisioner "local-exec" {
    command = "aws eks --region us-east-1 update-kubeconfig --name demo"
  }
}
###### Service creation ######
resource "kubectl_manifest" "svc" {
  depends_on = [aws_eks_node_group.public-nodes]
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: web-app-svc
spec:
  selector:
    app: mavenwebapp
  type: LoadBalancer
  ports:
  - port: 8080
    targetPort: 8080
YAML
}

##### Deployment #####
resource "kubectl_manifest" "deployment" {
  depends_on = [kubectl_manifest.svc]
  yaml_body  = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app-deployment
spec:
  revisionHistoryLimit: 10
  replicas: 1
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: mavenwebapp
  template:
    metadata:
      name: web-app-pod
      labels:
        app: mavenwebapp
    spec:
      containers:
        - name: web-app-container
          image: deepakshipurushotham/web-app:24
          ports:
            - containerPort: 8080
          resources:
            requests:
              cpu: 200m
              memory: 256Mi
            limits:
              cpu: 500m
              memory: 512Mi

YAML
}