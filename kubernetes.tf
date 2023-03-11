resource "kubernetes_deployment" "my_app" {

  depends_on = [aws_eks_node_group.Eks-node_group]
  metadata {
    name = "prestashop"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "prestashop"
      }
    }

    template {
      metadata {
        labels = {
          app = "prestashop"
        }
      }

      spec {
        container {
          image = "korede01/prestashop:v1.0"
          name  = "my-app"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "my_app_service" {
  depends_on = [kubernetes_deployment.my_app]
  metadata {
    name = "prestashop"
  }

  spec {
    selector = {
      app = "prestashop"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}





