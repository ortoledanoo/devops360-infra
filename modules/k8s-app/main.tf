resource "kubernetes_deployment_v1" "devops360-deployment" {
  metadata {
    name = "devops360-deployment"
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        service_account_name = kubernetes_service_account.app_service_account.metadata[0].name
        
        container {
          name  = "devops360-container"
          image = var.image_name

          port {
            container_port = 8000
          }

          env {
            name  = "DYNAMODB_TABLE_NAME"
            value = var.dynamodb_table_name
          }

          env {
            name  = "S3_BUCKET_NAME"
            value = var.s3_bucket_name
          }

          env {
            name  = "COGNITO_USER_POOL_ID"
            value = var.cognito_user_pool_id
          }

          env {
            name  = "COGNITO_USER_POOL_CLIENT_ID"
            value = var.cognito_user_pool_client_id
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "devops360-service" {
  metadata {
    name = "devops360-service"
    labels = {
      app = var.app_name
    }
  }

  spec {
    type = var.service_type
    
    selector = {
      app = var.app_name
    }

    port {
      port        = 80
      target_port = 8000
      protocol    = "TCP"
    }
  }
}

resource "kubernetes_ingress_v1" "devops360-ingress" {
  metadata {
    name = "devops360-ingress"
    annotations = {
      "kubernetes.io/ingress.class"                          = "alb"
      "alb.ingress.kubernetes.io/scheme"                     = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"                = "ip"
      "alb.ingress.kubernetes.io/listen-ports"               = "[{\"HTTP\": 80}]"
      "alb.ingress.kubernetes.io/healthcheck-path"           = "/"
      "alb.ingress.kubernetes.io/success-codes"              = "200-399"
      "alb.ingress.kubernetes.io/backend-protocol"           = "HTTP"
      "alb.ingress.kubernetes.io/tags"                       = "Environment=dev,ManagedBy=terraform,Project=devops360"
    }
  }

  spec {
    ingress_class_name = "alb"
    
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          
          backend {
            service {
              name = kubernetes_service_v1.weather_app.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}