output "website_endpoint" {
  value       = aws_s3_bucket_website_configuration.example-config.website_endpoint
  description = "The URL to access the statis site"
}
