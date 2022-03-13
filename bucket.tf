resource "aws_s3_bucket" "as3b" {
  bucket = "${var.PROJECT}-${var.ENVIRONMENT}-bucket"
  tags = {
    Name        = "${var.PROJECT}-${var.ENVIRONMENT}-bucket"
    Environment = var.ENVIRONMENT
  }
}

resource "aws_s3_bucket_acl" "as3ba" {
  depends_on = [
    aws_s3_bucket.as3b
  ]
  bucket = aws_s3_bucket.as3b.id
  acl    = "private"
}

# resource "aws_s3_bucket_versioning" "as3bv" {
#   depends_on = [
#     aws_s3_bucket.as3b
#   ]
#   bucket = aws_s3_bucket.as3b.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }
