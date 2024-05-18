variable "github_org" {
  type     = string
  nullable = false
  default  = "yevgen-grytsay"
}

variable "github_repository" {
  type     = string
  nullable = false
  default  = "kbot-flux-otel-monitoring-2"
}

variable "github_token" {
  sensitive = true
  type      = string
  nullable  = false
}

variable "kbot_tele_token" {
  type      = string
  nullable  = false
  sensitive = true
}
