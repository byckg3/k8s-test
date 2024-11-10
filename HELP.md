# k8s-test

### terraform commands
- terraform init
- terraform fmt
- terraform destroy -auto-approve


### aws cli commands
- aws eks get-token --cluster-name <CLUSTER_NAME>
- aws eks --region ap-northeast-1 update-kubeconfig \\\
  --name $(terraform output -raw cluster_name)


### k8s commands
- kubectl cluster-info
- kubectl get no( nodes )
- kubectl get po( pods )
- kubectl describe po <PO_NAME>
- kubectl get svc( services )
- kubectl get deploy( deployments )
- kubectl delete all --all
- kubectl delete deployment <DEPLOY_NAME>
- kubectl apply -f .
- kubectl rollout status deploy
- rm *.yaml


### references
  - [Manage Kubernetes resources via Terraform](https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-provider?variants=kubernetes%3Aeks)
