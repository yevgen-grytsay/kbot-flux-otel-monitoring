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


# resource "helm_release" "fluent" {
#   #   count = 0


#   name  = "fluent"
#   chart = "https://github.com/fluent/helm-charts/releases/download/fluent-bit-0.46.5/fluent-bit-0.46.5.tgz"

#   reset_values  = true
#   recreate_pods = true

#   values = [
#     file("${path.module}/otel/fluent-bit/helm-values.yaml")
#   ]
# }

# resource "helm_release" "opentelemetry_collector" {
#   #   count = 0


#   name  = "collector"
#   chart = "https://github.com/open-telemetry/opentelemetry-helm-charts/releases/download/opentelemetry-collector-0.90.1/opentelemetry-collector-0.90.1.tgz"

#   reset_values  = true
#   recreate_pods = true

#   values = [
#     file("${path.module}/otel/collector/helm-values.yaml")
#   ]
# }

# resource "helm_release" "loki" {
#   name = "loki"

#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "loki"
#   version    = "6.5.2"

#   reset_values  = true
#   recreate_pods = true

#   values = [
#     file("${path.module}/otel/loki/helm-values.yaml")
#   ]
# }

# resource "helm_release" "grafana" {
#   #   count = 0


#   name = "grafana"

#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "grafana"
#   version    = "7.3.11"

#   reset_values  = true
#   recreate_pods = true

#   values = [
#     file("${path.module}/otel/grafana/helm-values.yaml")
#   ]
# }

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
