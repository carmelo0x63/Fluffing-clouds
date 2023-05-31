resource "aws_s3_bucket" "example" {
  bucket = var.bucketName
}

resource "aws_s3_bucket_website_configuration" "example-config" {
  bucket = aws_s3_bucket.example.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "example-access" {
  bucket = aws_s3_bucket.example.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "example-policy" {
  bucket     = aws_s3_bucket.example.id
  policy     = templatefile("s3-policy.json", { bucket = var.bucketName })
  depends_on = [aws_s3_bucket_public_access_block.example-access]
}

