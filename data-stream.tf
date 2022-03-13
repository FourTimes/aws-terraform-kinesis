resource "aws_kinesis_stream" "aks" {
  encryption_type     = "NONE"
  name                = "${var.PROJECT}-${var.ENVIRONMENT}-kinesis-stream"
  retention_period    = 24
  shard_count         = 0
  shard_level_metrics = []
  tags = {
    Name        = "${var.PROJECT}-${var.ENVIRONMENT}-kinesis-stream"
    Environment = var.ENVIRONMENT
  }

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }
}
