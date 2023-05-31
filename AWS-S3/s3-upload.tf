resource "aws_s3_object" "example-index" {
  bucket       = aws_s3_bucket.example.id
  key          = "index.html"
  source       = "src/index.html"
  content_type = "text/html"
#  acl    = "public-read"
}

