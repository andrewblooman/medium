data "aws_iam_policy_document" "queue_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = ["arn:aws:sqs:*:*:cloudtrail-siem-events"]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.cloudtrail.arn]
    }
  }
}

resource "aws_sqs_queue" "siem_queue" {
  name   = "cloudtrail-siem-events"
  policy = data.aws_iam_policy_document.queue_policy.json
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.cloudtrail.id

  queue {
    queue_arn     = aws_sqs_queue.siem_queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
}