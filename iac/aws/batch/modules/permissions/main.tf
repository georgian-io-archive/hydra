resource "aws_iam_role" "compute_environment_service_role" {
  name                = var.compute_environment_service_role_name
  assume_role_policy  = data.aws_iam_policy_document.compute_environment_service_role_policy.json
}

data "aws_iam_policy_document" "compute_environment_service_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["batch.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "compute_environment_service_role_policy_attachment" {
  role        = aws_iam_role.compute_environment_service_role.name
  count       = length(var.compute_environment_service_iam_policy_arn)
  policy_arn  = var.compute_environment_service_iam_policy_arn[count.index]
}

resource "aws_iam_instance_profile" "compute_environment_instance_profile" {
  name = var.compute_environment_instance_role_name
  role = aws_iam_role.compute_environment_instance_role.name
}

resource "aws_iam_role" "compute_environment_instance_role" {
  name                = var.compute_environment_instance_role_name
  assume_role_policy  = data.aws_iam_policy_document.compute_environment_instance_role_policy.json
}

data "aws_iam_policy_document" "compute_environment_instance_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "compute_environment_instance_role_policy_attachment" {
  role        = aws_iam_role.compute_environment_instance_role.name
  count       = length(var.compute_environment_instance_iam_policy_arn)
  policy_arn  = var.compute_environment_instance_iam_policy_arn[count.index]
}

resource "aws_iam_role" "lambda_service_role" {
  name                = var.lambda_service_role_name
  assume_role_policy  = data.aws_iam_policy_document.lambda_service_role_policy.json
}

data "aws_iam_policy_document" "lambda_service_role_policy" {
  version   = "2012-10-17"

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_service_role_policy_attachment" {
  role        = aws_iam_role.lambda_service_role.name
  count       = length(var.lambda_service_iam_policy_arn)
  policy_arn  = var.lambda_service_iam_policy_arn[count.index]
}
