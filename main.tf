terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.0.12"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kind" {}

resource "kind_cluster" "default" {
  name = "mateusclira"
  wait_for_ready = true
  kind_config {
    kind = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
    }

    node {
      role = "worker"
      image = "kindest/node:v1.24.2"
    }

    node {
      role = "worker"
      image = "kindest/node:v1.24.2"
    }

    node {
      role = "worker"
      image = "kindest/node:v1.24.2"
    }
  }
}

provider "kubectl" {
  host = "${kind_cluster.default.endpoint}"
  cluster_ca_certificate = "${kind_cluster.default.cluster_ca_certificate}"
  client_certificate = "${kind_cluster.default.client_certificate}"
  client_key = "${kind_cluster.default.client_key}"
}

data "kubectl_file_documents" "crds" {
  content = file("olm/crds.yaml")
}

resource "kubectl_manifest" "crds_apply" {
  for_each  = data.kubectl_file_documents.crds.manifests
  yaml_body = each.value
  wait = true
  server_side_apply = true
}

data "kubectl_file_documents" "olm" {
  content = file("olm/olm.yaml")
}

resource "kubectl_manifest" "olm_apply" {
  depends_on = [data.kubectl_file_documents.crds]
  for_each  = data.kubectl_file_documents.olm.manifests
  yaml_body = each.value
}

provider "helm" {
  kubernetes {
    host = "${kind_cluster.default.endpoint}"
    cluster_ca_certificate = "${kind_cluster.default.cluster_ca_certificate}"
    client_certificate = "${kind_cluster.default.client_certificate}"
    client_key = "${kind_cluster.default.client_key}"
  }
}
/*
resource "helm_release" "argocd" {
  name  = "argocd"

  repository       = "https://github.com/argoproj/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "4.10.0"
  create_namespace = true

  values = [
    file("argocd/application.yaml")
  ]
}
/*
resource "kubernetes_service" "argocd" {
  metadata {
    name = "argocd"
  }

  spec {
    selector = {
      app = argocd.mateusclira
    }

    session_affinity = "ClientIP"
    type             = "LoadBalancer"

    port {
      port        = 80
      target_port = 80
    }
  }

   ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["argocd-127-0-0-1.nip.io"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["argocd-127-0-0-1.nip.io"]
    }
  wait_for_load_balancer = "false"
}

#Here starts the wordpress creation 

# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/guides/v2-upgrade-guide#changes-to-the-load_balancers_ingress-block-on-service-and-ingress

resource "kubernetes_persistent_volume_claim" "wordpress" {
  metadata {
    name = "wp-pv-claim"
    labels = {
      app = "wordpress"
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "20Gi"
      }
    }
    volume_name = mateusclira.wordpress
  }
}

resource "kubernetes_replication_controller" "wordpress" {
  metadata {
    name = "wordpress"
    labels = {
      app = "mateusclira"
    }
  }
  spec {
    selector = {
      app  = "mateusclira"
      tier = "frontend"
    }
    template {
      container {
        image = "wordpress:5.8-apache"
        name  = "wordpress"

        env {
          name  = "WORDPRESS_DB_HOST"
          value = "wordpress-mysql"
        }
        env {
          name = "WORDPRESS_DB_PASSWORD"
          value_from {
            secret_key_ref {
              name = kubernetes_secret.mysql.metadata.name
              key  = "password"
            }
          }
        }

        port {
          container_port = 80
          name           = "wordpress"
        }

        volume_mount {
          name       = "wordpress-persistent-storage"
          mount_path = "/var/www/html"
        }
      }
    }
  }
}

resource "kubernetes_service" "wordpress" {
  metadata {
    name = "wordpresss"
  }

  spec {
    selector = {
      app = wordpress
    }

    session_affinity = "ClientIP"
    type             = "LoadBalancer"

    port {
      port        = 80
      target_port = 80
    }
  }

   ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["wp-127-0-0-1.nip.io"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["wp-127-0-0-1.nip.io"]
    }
  wait_for_load_balancer = "false"
}

output "lb_ip" {
  value = kubernetes_service.wordpress.load_balancer_ingress[0].ip
} */