output "app_mesh" {
  value = aws_appmesh_mesh.cea_app_mesh.arn
}

output "virtual_node" {
  value = aws_appmesh_virtual_node.api_customer_node.arn
}