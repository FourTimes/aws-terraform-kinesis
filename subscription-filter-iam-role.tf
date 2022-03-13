resource "aws_iam_role" "subscription-filter-iam-role" {
  name = "${var.PROJECT}-${var.ENVIRONMENT}-subscription-filter-role"
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "logs.${var.REGION}.amazonaws.com"
        }
      },
    ]
    Version = "2008-10-17"
  })
}

resource "aws_iam_policy" "subscription-filter-iam-role" {
  name        = "${var.PROJECT}-${var.ENVIRONMENT}-subscription-filter-role"
  description = "${var.PROJECT}-${var.ENVIRONMENT}-subscription-filter-role"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "subscriptionFilterRole",
        "Effect" : "Allow",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "subscription-filter-iam-role" {
  name       = "${var.PROJECT}-${var.ENVIRONMENT}-subscription-filter-role"
  roles      = [aws_iam_role.subscription-filter-iam-role.name]
  policy_arn = aws_iam_policy.subscription-filter-iam-role.arn
}
