output "alb_dns_name" {
  description = "The hostname of the LB. Use this to access the WP site."
  value       = aws_lb.wp_alb.dns_name
}

output "rds_endpoint" {
  description = "The connection endpoint for RDS."
  value       = aws_db_instance.wordpress_db.endpoint
}
