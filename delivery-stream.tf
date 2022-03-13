resource "aws_kinesis_firehose_delivery_stream" "akfds" {
  destination    = "extended_s3"
  destination_id = "destinationId-000000000001"
  name           = "${var.PROJECT}-${var.ENVIRONMENT}-firehose-delivery-stream"
  version_id     = "1"
  tags = {
    Name        = "${var.PROJECT}-${var.ENVIRONMENT}-firehose-delivery-stream"
    Environment = var.ENVIRONMENT
  }
  extended_s3_configuration {
    bucket_arn         = aws_s3_bucket.as3b.arn
    buffer_interval    = 300
    buffer_size        = 5
    compression_format = "UNCOMPRESSED"
    role_arn           = aws_iam_role.delivery-stream-iamrole.arn
    s3_backup_mode     = "Disabled"
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/${var.PROJECT}-${var.ENVIRONMENT}-firehose-delivery-stream"
      log_stream_name = "DestinationDelivery"
    }
    processing_configuration {
      enabled = false
    }
  }
  server_side_encryption {
    enabled  = false
    key_type = "AWS_OWNED_CMK"
  }
}

resource "aws_iam_role" "delivery-stream-iamrole" {
  name = "${var.PROJECT}-${var.ENVIRONMENT}-firehose-delivery-stream-role"
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      },
    ]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "delivery-stream-iamrole" {
  name        = "${var.PROJECT}-${var.ENVIRONMENT}-firehose-delivery-stream-policy"
  description = "${var.PROJECT}-${var.ENVIRONMENT}-firehose-delivery-stream-policy"
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "glue:GetTable",
        "glue:GetTableVersion",
        "glue:GetTableVersions"
      ],
      "Resource": "*"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ],
      "Resource": "*"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": ["lambda:InvokeFunction", "lambda:GetFunctionConfiguration"],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": ["kms:GenerateDataKey", "kms:Decrypt"],
      "Resource": "*"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": ["logs:PutLogEvents"],
      "Resource": "*"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords",
        "kinesis:ListShards"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": ["kms:Decrypt"],
      "Resource": "*"
    }
  ]
})
}

resource "aws_iam_policy_attachment" "aipasp" {
  name       = "${var.PROJECT}-${var.ENVIRONMENT}-firehose-delivery-stream-policy"
  roles      = [aws_iam_role.delivery-stream-iamrole.name]
  policy_arn = aws_iam_policy.delivery-stream-iamrole.arn
}