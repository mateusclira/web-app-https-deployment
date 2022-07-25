# Manage Kubernetes Cluster with Terraform and Web API Example

In this project I'm demonstrating you how to use [Terraform](https://www.terraform.io/) together to create and manage the Kubernetes cluster on [Kind](https://kind.sigs.k8s.io/).

## Prerequisites
1. Terraform CLI installed
2. Docker
3. Kustomize and Sops

## Getting Started

First, clone the repo:
```shell
$ git clone https://github.com/mateusclira/challenge-cloud-engineer.git
$ cd challenge-cloud-engineer
```

Then initialize Terraform config: 
```shell
terraform init
```

Review the actions plan: 
```shell
terraform plan
```

Run the Terraform actions: 
```shell
terraform apply
```

### You have to install the ingress-nginx controler 
```shell 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/cloud/deploy.yaml
```

#### Run this to install the cert-manager

First install the CRDs:
```shell 
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.2/cert-manager.crds.yaml
```
Then install the cert-manager:
```shell 
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.8.2 --set prometheus.enabled=false --set webhook.timeoutSeconds=4
```

### In order to apply the .yaml files 
```shell 
kubectl apply -f .\kubernetes 
```


## You still need to create a DNS name or if possible create a DNS zone in order to have a named host as I used in this example git.

### Uses on this Github include:
1. Terraform Kind Cluster Creation
2. Ksops to secure secrets
3. Deploy of a Web Application
4. Ingress to deploy HTTPS on a Kubernetes Cluster (Incomplete)


## Guides for study 

1. Ksops
- https://blog.oddbit.com/post/2021-03-09-getting-started-with-ksops/

2. Kubernetes with Terraform and ArgoCD
- https://piotrminkowski.com/2022/06/28/manage-kubernetes-cluster-with-terraform-and-argo-cd/
- https://www.linkedin.com/pulse/automating-kubernetes-cluster-cicd-setup-terraform-argo-stephen-kuntz/

3. Kind
- https://faun.pub/creating-a-kubernetes-cluster-for-development-with-kind-189df2cb0792

4. SSL/TLS
- https://dev.to/techschoolguru/how-to-create-sign-ssl-tls-certificates-2aai
- [Generate SSL](https://phoenixnap.com/kb/kubernetes-ssl-certificates)

5. Network on Cluster
- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)

6. Configuring Ingress
- https://devopscube.com/configure-ingress-tls-kubernetes/

