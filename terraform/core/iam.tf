# https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws#configuring-the-role-and-trust-policy


resource "aws_iam_role" "app" {
  name               = "${local.name_prefix}-app-main"
  assume_role_policy = data.aws_iam_policy_document.trusted.json
  tags               = local.common_tags
}

data "aws_iam_policy_document" "trusted" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${local.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:josefloressv/kcd_colombia_webapp_color:*"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "app" {
  role       = aws_iam_role.app.name
  policy_arn = aws_iam_policy.app.arn
}

resource "aws_iam_policy" "app" {
  name        = "${local.name_prefix}-app-main"
  description = "More granular access to IAM resources for application role. Terraform managed"
  policy      = data.aws_iam_policy_document.app.json
  tags        = local.common_tags
}

data "aws_iam_policy_document" "app" {

  statement { # Actions only support the all resources wildcard('*')
    sid = "AllResources"

    actions = [
      "ecs:List*",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:ModifyRule",
      "ecs:DescribeTaskDefinition",
      "ecs:DeregisterTaskDefinition",
      "ecs:RegisterTaskDefinition",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:SetDesiredCapacity",
      "ecr:GetAuthorizationToken",
    ]

    resources = ["*"]
  }

  statement { # ECR Push

    actions = [
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage"
    ]

    resources = [
      "arn:aws:ecr:us-east-1:${local.aws_account_id}:repository/${var.application}*"
    ]
  }

  statement { # ECS Deploy
    sid = "ECSDeploy"

    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService"
    ]

    resources = [
      "arn:aws:ecs:us-east-1:${local.aws_account_id}:service/${var.platform}*/${var.application}*",
    ]
  }

  statement { # IAM Attach role to Task Definition
    sid = "IAMAttachRoleTaskDefinition"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      "arn:aws:iam::${local.aws_account_id}:role/${var.application}*",
    ]
  }

  statement { # Retrieve SSM Parameters
    sid    = "RetrieveSSMParameters"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]
    resources = [
      "arn:aws:ssm:us-east-1:${local.aws_account_id}:parameter/${var.platform}/*",
    ]
  }

  statement { # Modify SSM Parameters
    sid     = "ModifySSMParameters"
    effect  = "Allow"
    actions = ["ssm:PutParameter"]
    resources = [
      "arn:aws:ssm:us-east-1:${local.aws_account_id}:parameter/${var.platform}/${var.application}/${var.environment}/docker_tag",
      "arn:aws:ssm:us-east-1:${local.aws_account_id}:parameter/${var.platform}/${var.application}/${var.environment}/active_color"
    ]
  }

  statement { # Register Scalable Target
    sid     = "AppAutoScalingService"
    effect  = "Allow"
    actions = ["application-autoscaling:RegisterScalableTarget"]
    resources = [
      "arn:aws:application-autoscaling:us-east-1:${local.aws_account_id}:scalable-target/*"
    ]
  }

}