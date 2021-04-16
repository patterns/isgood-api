
resource "kubernetes_namespace" "examplenamespace" {
  # namespace is the shared scope for the resources

  metadata {
    labels = {
      app = "example"
    }
    name = "examplenamespace"
  }
}

resource "kubernetes_deployment" "exampledeployment" {
  metadata {
    name      = "exampledeployment"
    namespace = "examplenamespace"
    labels = {
      app = "hello-world-example"
    }
  }

  # expected state of set of pods 
  spec {
    ##replicas = 1
    selector {
      match_labels = {
        app = "hello-world-example"
      }
    }
    template {
      metadata {
        labels = {
          app = "hello-world-example"
        }
      }
      spec {
        # public docker image
        container {
          image = "heroku/nodejs-hello-world"
          name  = "hello-world"
        }
      }
    }
  }
}

resource "kubernetes_service" "examplesvc" {
  depends_on = [kubernetes_deployment.exampledeployment]

  metadata {
    labels = {
      app = "hello-world-example"
    }
    name      = "examplesvc"
    namespace = "examplenamespace"
  }

  # how a group of pods are accessed
  spec {
    port {
      name        = "api"
      port        = 3000
      target_port = 3000
    }
    selector = {
      app = "hello-world-example"
    }
    type = "ClusterIP"
  }
}

resource "helm_release" "example" {
  # ingress controller for outside to access our service

  name       = "example"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "3.15.2"
  namespace  = "examplenamespace"
  timeout    = 300

  values = [<<EOF
controller:
  admissionWebhooks:
    enabled: false
  electionID: ingress-controller-leader-internal
  ingressClass: public-examplenamespace
  podLabels:
    app: example
  service:
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: nlb
  scope:
    enabled: true
rbac:
  scope: true
EOF
  ]
}

resource "kubernetes_ingress" "exampleingress" {
  metadata {
    labels = {
      app = "example"
    }
    name      = "exampleingress"
    namespace = "examplenamespace"
    annotations = {
      "kubernetes.io/ingress.class" : "public-examplenamespace"
    }
  }

  # ingress for ingress controller
  spec {
    rule {
      http {
        path {
          path = "/"
          backend {
            service_name = "hello-world-example"
            service_port = 3000
          }
        }
      }
    }
  }
}
