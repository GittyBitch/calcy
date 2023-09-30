provider "random" {}

resource "random_id" "bucket_id" {
  byte_length = 8
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "calcy-${random_id.bucket_id.hex}"

}

resource "aws_s3_bucket_website_configuration" "my_website" {
  bucket = "calcy-${random_id.bucket_id.hex}"
    index_document { 
	suffix="index.html" 
}

}

resource "aws_s3_bucket_public_access_block" "my_public_access_block" {
  bucket = aws_s3_bucket.my_bucket.bucket
  depends_on = [aws_s3_bucket.my_bucket]
  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.bucket
  depends_on = [aws_s3_bucket_public_access_block.my_public_access_block]
  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"PublicReadForGetBucketObjects",
    "Effect":"Allow",
    "Principal": "*",
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::${aws_s3_bucket.my_bucket.id}/*"]
  }]
}
EOF
}

# FIXME: no auto update currently
resource "aws_s3_object" "html_files" {
  for_each = fileset("${path.module}/html/", "*") 
  depends_on = [null_resource.test_endpoint]
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = each.value
  source = "${path.module}/html/${each.value}"
  content_type = "text/html"
  etag         = filemd5("${path.module}/html/${each.value}")
}

output "website_url" {
# FIXME
  value = "http://${aws_s3_bucket.my_bucket.bucket}.s3-website.eu-central-1.amazonaws.com/"
  description = "The URL of the hosted website"
}
