variable "domain_name" {
  default = "korede.me"
}


resource "kubernetes_ingress_v1" "microservice" {
    depends_on = [helm_release.nginix-ingress]
  metadata {
    name = "sock"
    namespace = "sock-shop"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
  }
 spec {
    rule {
      host = "microservice.korede.me"
      http {
        path {
          backend {
            service {
                name = "front-end"
                port {
                    number = 8079
                    }
                }
            }
         }
       }
     }
   }
}



resource "kubernetes_ingress_v1" "voting" {
    depends_on = [helm_release.nginix-ingress]
  metadata {
    name = "voting"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
  }
 spec {
    rule {
      host = "voting.korede.me"
      http {
        path {
          backend {
            service {
                name = "voting-service"
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



resource "kubernetes_ingress_v1" "grafana" {
    depends_on = [helm_release.nginix-ingress]
  metadata {
    name = "grafana"
    namespace = "monitoring"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
  }
 spec {
    rule {
      host = "grafana.korede.me"
      http {
        path {
          backend {
            service {
                name = "prometheus-grafana"
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


resource "kubernetes_ingress_v1" "prometheus" {
    depends_on = [helm_release.nginix-ingress]
  metadata {
    name = "prometheus"
    namespace = "monitoring"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
  }
 spec {
    rule {
      host = "prometheus.korede.me"
      http {
        path {
          backend {
            service {
                name = "prometheus-kube-prometheus-prometheus"
             port {
                number = 9090
            } 

            } 
            
          }
        }
      }
    }
 }
}





