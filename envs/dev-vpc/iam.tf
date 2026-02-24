data "aws_iam_policy_document" "ec2_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "private_ec2" {
  name               = "dev-private-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
}

data "aws_iam_policy_document" "private_ec2_s3_read" {
  statement {
    sid     = "ListBucketForPrefix"
    effect  = "Allow"
    actions = ["s3:ListBucket"]

    resources = ["arn:aws:s3:::${var.state_bucket_name}"]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["${var.state_bucket_prefix}*"]
    }
  }

  statement {
    sid     = "GetObjectsUnderPrefix"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    resources = ["arn:aws:s3:::${var.state_bucket_name}/${var.state_bucket_prefix}*"]
  }
}

resource "aws_iam_policy" "private_ec2_s3_read" {
  name   = "dev-private-ec2-s3-read"
  policy = data.aws_iam_policy_document.private_ec2_s3_read.json
}

resource "aws_iam_role_policy_attachment" "private_ec2_attach_s3_read" {
  role       = aws_iam_role.private_ec2.name
  policy_arn = aws_iam_policy.private_ec2_s3_read.arn
}

resource "aws_iam_instance_profile" "private_ec2" {
  name = "dev-private-ec2-profile"
  role = aws_iam_role.private_ec2.name
}
