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

variable "kubeconfig_path" {
  type    = string
  default = "" 
}

provider "kubernetes" {
  config_path = var.kubeconfig_path != "" ? var.kubeconfig_path : null
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path != "" ? var.kubeconfig_path : null
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
