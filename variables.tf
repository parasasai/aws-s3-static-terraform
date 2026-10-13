variable "aws_region" {
  description = "AWS_region"
  type        = string
  default     = "eu-central-1"
}

variable "bucket_name" {
  description  = "globally Unique s3 bucket name"
  type         = string 
  default      = "my-static-site-host-9989202218"
 }
 
