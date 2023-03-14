resource "kubernetes_config_map" "my-config-map" {
  depends_on = [aws_eks_node_group.Eks-node_group]
  metadata {
    name = "mongo-configmap"
  }
  data = {
    "mongo_url" = "mongo-service"
  }
}

resource "kubernetes_secret" "mongo-secret" {
  metadata {
    name = "mongo-secret"
  }

  type = "Opaque"

  data = {
    mongo-user     = "korede"
    mongo-password = "admin"
  }
}


resource "kubernetes_deployment" "mongodb" {
  depends_on = [kubernetes_config_map.my-config-map]
  metadata {
    name = "mongo-db"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mongo-db"
      }
    }

    template {
      metadata {
        labels = {
          app = "mongo-db"
        }
      }

      spec {
        container {
          name = "mongo-db"
          image = "mongo:5.0"

          resources {
            limits = {
              memory = "128Mi"
              cpu    = "500m"
            }
          }

          port {
            container_port = 27017
          }

           env {
            name = "MONGO_INITDB_ROOT_USERNAME"
            value_from {
              secret_key_ref {
                name = "mongo-secret"
                key  = "mongo-user"
              }
            }
          }

           env {
            name = "MONGO_INITDB_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mongo-secret"
                key  = "mongo-password"
              }
            }
          }
        }
      }
    }
  }
}




resource "kubernetes_service" "mongo-service" {
  depends_on = [kubernetes_deployment.mongodb]
  metadata {
    name = "mongo-service"
  }

  spec {
    selector = {
      app = "mongo-db"
    }

    port {
      port        = 27017
      target_port = 27017
    }
  }
}


resource "kubernetes_deployment" "web_app" {
  depends_on = [kubernetes_deployment.mongodb]
 metadata {
  name = "web-app"
  }
 
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "web-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "web-app"
        }
      }

      spec {
        container {
          name = "web-app"
          image = "nanajanashia/k8s-demo-app:v1.0"

          resources {
            limits = {
              memory = "128Mi"
              cpu    = "500m"
            }
          }

          port {
            container_port = 3000
          }

           env {
            name = "USER_NAME"
            value_from {
              secret_key_ref {
                name = "mongo-secret"
                key  = "mongo-user"
              }
            }
          }

           env {
            name = "USER_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mongo-secret"
                key  = "mongo-password"
              }
            }
          }

          env {
            name = "DB_URL"
            value_from {
              config_map_key_ref {
                name = "mongo-configmap"
                key  = "mongo_url"
              }
            }
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "my_app_service" {
  depends_on = [kubernetes_deployment.web_app]
  metadata {
    name = "web-app-service"
  }

  spec {
    selector = {
      app = "web-app"
    }

    port {
      port        = 3000
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}


resource "kubectl_manifest" "test" {
  depends_on = [kubernetes_deployment.web_app]
  count     = length(data.kubectl_filename_list.manifests.matches)
  yaml_body = file(element(data.kubectl_filename_list.manifests.matches, count.index))
}





