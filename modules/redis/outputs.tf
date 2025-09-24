output "elasticache_cluster_hostname" {
  value       = aws_elasticache_cluster.staging.cache_nodes[0].address
  description = "The hostname of the ElastiCache cluster node"
}

output "app_name" {
  value = var.app_name
}