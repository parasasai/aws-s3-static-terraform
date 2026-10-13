terraform{
  required_providers {
  aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
 }
provider "aws"{
  region = var.aws_region
 }
 
resource "aws_s3_bucket" "website" {
  bucket             = var.bucket_name
  force_destory      = true
  
  tags = {
    Name           = "static website Bucket" 
	Environment    = "Dev" 
	}
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket                  = aws_s3_bucket.website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
    }

  error_document {
    key = "error.html"
    }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  depends_on = [aws_s3_bucket_public_access_block.bucket]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
    {
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.website.arn}/*"
    }
   ]
  }
 )
}

resource "aws_s3_object" "index" {
  bucket         = aws_s3_bucket.website.id
  key            = "index.html"
  source         = "${path.module}/website/index.html"
  content_type   = "text/html"
  etag           = filemd5("${path.module}/website/index.html")
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.website.id
  key          = "error.html"
  source       = "${path.module}/website/error.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/website/error.html")
}
	
	
