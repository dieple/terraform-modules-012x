##########
# K8s SA #
##########
resource "kubernetes_service_account" "this" {
  automount_service_account_token = true
  metadata {
    name        = var.name
    namespace   = var.sa_ns
    annotations = {
      "eks.amazonaws.com/role-arn"   = var.alb_role_arn
    }
    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

###############
# Clusterrole #
###############
resource "kubernetes_cluster_role" "this" {
  metadata {
    name = var.name

    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  rule {
    api_groups = [
      "",
      "extensions",
    ]

    resources = [
      "configmaps",
      "endpoints",
      "events",
      "ingresses",
      "ingresses/status",
      "services",
    ]

    verbs = [
      "create",
      "get",
      "list",
      "update",
      "watch",
      "patch",
    ]
  }

  rule {
    api_groups = [
      "",
      "extensions",
    ]

    resources = [
      "nodes",
      "pods",
      "secrets",
      "services",
      "namespaces",
    ]

    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = var.name

    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.this.metadata[0].name
  }

  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = var.sa_ns
  }
}

#################################
# Ingress Controller Deployment #
#################################
resource "kubernetes_deployment" "this" {
  depends_on = [kubernetes_cluster_role_binding.this]

  metadata {
    name      = var.name
    namespace = var.sa_ns

    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/version"    = "v${var.aws_alb_ingress_controller_version}"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/name" = var.name
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name"    = var.name
          "app.kubernetes.io/version" = var.aws_alb_ingress_controller_version
        }
      }

      spec {
        dns_policy     = "ClusterFirst"
        restart_policy = "Always"

        container {
          name                     = "server"
          image                    = var.aws_alb_ingress_controller_docker_image
          image_pull_policy        = "Always"
          termination_message_path = "/dev/termination-log"

          args = [
            "--ingress-class=alb",
            "--cluster-name=${var.cluster_name}",
            "--aws-vpc-id=${var.vpc_id}",
            "--aws-region=${var.region}",
            "--aws-max-retries=10",
          ]

          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name       = kubernetes_service_account.this.default_secret_name
            read_only  = true
          }

          port {
            name           = "health"
            container_port = 10254
            protocol       = "TCP"
          }

          readiness_probe {
            http_get {
              path   = "/healthz"
              port   = "health"
              scheme = "HTTP"
            }

            initial_delay_seconds = 30
            period_seconds        = 60
            timeout_seconds       = 3
          }

          liveness_probe {
            http_get {
              path   = "/healthz"
              port   = "health"
              scheme = "HTTP"
            }

            initial_delay_seconds = 60
            period_seconds        = 60
          }
        }

        volume {
          name = kubernetes_service_account.this.default_secret_name

          secret {
            secret_name = kubernetes_service_account.this.default_secret_name
          }
        }

        service_account_name             = kubernetes_service_account.this.metadata[0].name
        termination_grace_period_seconds = 60
      }
    }
  }
}