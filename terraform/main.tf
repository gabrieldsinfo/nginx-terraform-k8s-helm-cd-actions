terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13.2"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "kubernetes_namespace" "nginx_app" {
  metadata {
    name = "nginx-terraform"
  }
}

resource "helm_release" "nginx_chart" {
  name       = "nginx-auto"
  chart      = "../helm/nginx-chart"
  namespace  = kubernetes_namespace.nginx_app.metadata[0].name
  create_namespace = false
}
