resource "kubernetes_namespace" "istio_system" {
  count = var.enable_istio == "true" ? 1 : 0
  metadata {
    name = "istio-system"
  }
}

data "helm_repository" "istio_repo" {
  depends_on = [module.tiller]
  count      = var.enable_istio == "true" ? 1 : 0
  name       = "istio.io"
  url        = "https://storage.googleapis.com/istio-release/releases/${var.istio_helm_release_version}/charts/"
}

resource "helm_release" "istio_init" {
  depends_on = [module.tiller]
  count      = var.enable_istio == "true" ? 1 : 0
  name       = "istio-init"
  repository = data.helm_repository.istio_repo[0].name
  chart      = "istio-init"
  namespace  = kubernetes_namespace.istio_system[0].metadata[0].name
  wait       = true
  # give istio_init time to set up
  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "helm_release" "istio" {
  depends_on = [helm_release.istio_init]
  count      = var.enable_istio == "true" ? 1 : 0
  name       = "istio"
  repository = data.helm_repository.istio_repo[0].name
  chart      = "istio"
  namespace  = kubernetes_namespace.istio_system[0].metadata[0].name
  wait       = true

  set {
    name  = "kiali.enabled"
    value = "true"
  }
}

