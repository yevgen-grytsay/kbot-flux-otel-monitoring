provider "flux" {
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = "microk8s"
  }

  git = {
    url = "https://github.com/${var.github_org}/${var.github_repository}"
    http = {
      username = var.github_org
      password = var.github_token
    }
  }
}

resource "flux_bootstrap_git" "this" {
  path = "cluster"
}

# resource "helm_release" "prometheus" {
#   count = 0

#   name = "prometheus"

#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "prometheus"
#   version    = "25.21.0"

#   reset_values  = true
#   recreate_pods = true

#   values = [
#     file("${path.module}/otel/prometheus/helm-values.yaml")
#   ]
# }
