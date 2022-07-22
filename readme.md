# Manage Kubernetes Cluster with Terraform and Argo CD [![Twitter](https://img.shields.io/twitter/follow/piotr_minkowski.svg?style=social&logo=twitter&label=Follow%20Me)](https://twitter.com/piotr_minkowski)

In this project I'm demonstrating you how to use [Terraform](https://www.terraform.io/) together with [Argo CD](https://argo-cd.readthedocs.io/en/stable/) to create and manage the Kubernetes cluster on [Kind](https://kind.sigs.k8s.io/).

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

## Results

After running the previous command you receive:
* 3-nodes Kind cluster running locally
* OLM (Operator Lifecycle Manager) installed on Kind
* Argo CD installed on Kind
* Kafka Strimzi operator ready to use
* 3-node Kafka cluster created on Kind
* Wordpress Vanilla installed on Kind
* Both Wordpress and Argo opened to http and https using ingress