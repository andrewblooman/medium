variable "account_id" {
  type    = string
  default = "ACCOUNT_ID"
}

variable "oidc_provider" {
  type    = string
  default = "gitlab.com"
}

variable "gitlab_project" {
  type    = string
  default = "PROJECT_PATH"
}