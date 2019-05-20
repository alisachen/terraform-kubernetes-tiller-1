variable "cluster_type" {
  value = "astro.steven-miller.me"
  type    = "string"
}

variable "git_clone_from" {
  default = "https://github.com/astronomer/helm.astronomer.io.git"
  type = "string"
}

variable "astronomer_version" {
  default = "master"
  type = "string"
}

variable "base_domain" {
  # TODO
  default = "astro.steven-miller.me"
  type = "string"
}
