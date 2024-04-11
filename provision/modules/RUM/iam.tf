data "aws_iam_policy_document" "authenticated" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.this.id]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["unauthenticated"]
    }
  }
}

resource "aws_iam_role" "authenticated" {
  name               = "${var.name}-rum-cognito-unauthenticated"
  assume_role_policy = data.aws_iam_policy_document.authenticated.json
}

data "aws_iam_policy_document" "unauthenticated_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "rum:PutRumEvents"
    ]
    resources = [aws_rum_app_monitor.this.arn]
  }
}

resource "aws_iam_policy" "unauthenticated" {
  name        = "${var.name}-rum-cognito-authenticated"
  description = "Policy allowing invocation of Cognito identity Pool and RUM"
  policy      = data.aws_iam_policy_document.unauthenticated_role_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_rum_policy" {
  policy_arn = aws_iam_policy.unauthenticated.arn
  role       = aws_iam_role.authenticated.name
}

resource "aws_cognito_identity_pool_roles_attachment" "main" {
  identity_pool_id = aws_cognito_identity_pool.this.id

  roles = {
    "unauthenticated" = aws_iam_role.authenticated.arn
  }
}
