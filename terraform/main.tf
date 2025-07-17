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
}

provider "helm" {
  kubernetes {
  }
}

resource "kubernetes_namespace" "nginx_app" {
  metadata {
    name = "nginx-terraform"
  }
}

resource "helm_release" "nginx_chart" {
  name             = "nginx-auto"
  chart            = "../helm/nginx-chart"
  namespace        = kubernetes_namespace.nginx_app.metadata[0].name
  create_namespace = false
}
