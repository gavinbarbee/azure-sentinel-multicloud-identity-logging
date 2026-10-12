# OIDC identity provider + IAM role that the Microsoft Sentinel
# "Amazon Web Services S3" connector assumes to read CloudTrail logs.
# No AWS access keys are created or stored anywhere.

resource "aws_iam_openid_connect_provider" "sentinel" {
  url            = "https://sts.windows.net/${var.sentinel_oidc_tenant_id}/"
  client_id_list = [var.sentinel_oidc_audience]
  tags           = local.tags
}

data "aws_iam_policy_document" "sentinel_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.sentinel.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "sts.windows.net/${var.sentinel_oidc_tenant_id}/:aud"
      values   = [var.sentinel_oidc_audience]
    }

    # Only sessions for MY Sentinel workspace can assume this role
    condition {
      test     = "StringEquals"
      variable = "sts:RoleSessionName"
      values   = ["MicrosoftSentinel_${var.sentinel_workspace_id}"]
    }
  }
}

# The connector requires the role name to start with "OIDC_"
resource "aws_iam_role" "sentinel_reader" {
  name               = "OIDC_gavinbarbee-sentinel-reader"
  assume_role_policy = data.aws_iam_policy_document.sentinel_trust.json
  tags               = local.tags
}

data "aws_iam_policy_document" "sentinel_read" {
  statement {
    sid       = "ReadCloudTrailObjects"
    actions   = ["s3:GetObject", "s3:ListBucket", "s3:GetBucketLocation"]
    resources = [aws_s3_bucket.cloudtrail.arn, "${aws_s3_bucket.cloudtrail.arn}/*"]
  }

  statement {
    sid = "ConsumeNotificationQueue"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:ChangeMessageVisibility",
      "sqs:GetQueueUrl",
      "sqs:GetQueueAttributes",
    ]
    resources = [aws_sqs_queue.cloudtrail.arn]
  }
}

resource "aws_iam_role_policy" "sentinel_read" {
  name   = "policy-gavinbarbee-sentinel-read"
  role   = aws_iam_role.sentinel_reader.id
  policy = data.aws_iam_policy_document.sentinel_read.json
}
