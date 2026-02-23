# App Mesh
locals {
  service_dns = "${var.service_name}.${var.namespace}.svc.cluster.local"

  # Paths where Envoy will read the certificates
  cert_chain_path = "/certs/tls.crt"
  private_key_path = "/certs/tls.key"
  ca_cert_path     = "/certs/ca.crt"
}

resource "aws_appmesh_mesh" "cea_app_mesh" {
  name = var.mesh_name

  spec {
    egress_filter {
      type = "ALLOW_ALL" # Allow all outbound traffic from services in the mesh to external services
    }
  }

  tags = {
    Usage               = var.project_name
  }
}

# Virtual Node for API Customer Service
# The micro-service will only accept traffic authenticated by valid certificates inside the App Mesh
# PREREQUISITES:
# 1. cer-manager must be installed in EKS
# 2. Create a ClusterIssuer in Kubernetes that references the ACM Private CA ARN using var.acm_pca_arn
# 3. Create a Certificate resource in Kubernetes that references the ClusterIssuer and includes the service
# 4. Mount the generated secret inside the Pod at /certs
resource "aws_appmesh_virtual_node" "api_customer_node" {
  name      = var.virtual_node_name
  mesh_name = aws_appmesh_mesh.cea_app_mesh.name

  spec {
    # Inbound listener for the virtual node
    listener {
      port_mapping {
        port     = var.app_port
        protocol = "http"
      }

      tls {
        # The virtual node will reject unencrypted traffic and only accept mTLS traffic with valid client certificates
        mode = "STRICT" # Enforce mTLS for all traffic to this virtual node

        certificate {
          file {
            certificate_chain = local.cert_chain_path
            private_key       = local.private_key_path
          }
        }

        validation {
          trust {
            # Trust only certificates issued by the specified ACM Private CA for mTLS authentication
            file {
              certificate_chain = local.ca_cert_path
            }
          }

          # App Mesh uses SAN (Subject Alternative Name) to validate identities. (Zero trust model)
          # Validate that the client certificate's SAN matches the expected service DNS name
          # to ensure only legitimate clients can connect
          subject_alternative_names {
            match {
              exact = [ local.service_dns ]
            }
          }
        }
      }
    }

    # Outbound traffic policy for the virtual node
    backend_defaults {
      client_policy {
        tls {
          enforce = true   # Enforce mTLS for all outbound traffic from this virtual node to other nodes in the mesh

          validation {
            trust {
              file {
                certificate_chain = local.ca_cert_path # Use the same CA for validating other nodes in the mesh
              }
            }
          }
        }
      }
    }

    service_discovery {
      dns {
        hostname = local.service_dns # Service discovery using the Kubernetes service DNS name
      }
    }
  }

  tags = {
    Usage               = var.project_name
  }
}