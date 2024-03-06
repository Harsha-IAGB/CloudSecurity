terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.0"
    }
    # azurerm = {
    #   source = "hashicorp/azurerm"
    #   version = "3.94.0"
    # }
  }
}

provider "aws" {
  # Configuration options
  profile = "ENPM665"
  region  = "us-east-1"
}

resource "aws_iam_saml_provider" "azure" {
  name                   = "EntraID-ENPM665-Tf"
  saml_metadata_document = file("../../../AWS Single-Account Access ENPM665.xml")
  tags = {
    ASD = "20240305"
  }
}

resource "aws_iam_role" "entraid_admins_tf" {
  name = "entraid-admins-tf"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : aws_iam_saml_provider.azure.arn
        },
        "Action" : "sts:AssumeRoleWithSAML",
        "Condition" : {
          "StringEquals" : {
            "SAML:aud" : "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })
  tags = {
    ASD = "20240305"
  }
}

resource "aws_iam_policy" "entraid_ssouserrole_policy" {
  name        = "EntraID-SSOUserRole-Policy-Tf"
  path        = "/"
  description = "Created using Terraform"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:ListRoles"
        ],
        "Resource" : "*"
      }
    ]
  })
  tags = {
    ASD = "20240305"
  }
}

resource "aws_iam_user" "entraidrolemanager" {
  name = "EntraIDRoleManagerTf"
  path = "/"
  tags = {
    ASD = "20240305"
  }
}

resource "aws_iam_user_policy_attachment" "entraidrolemanager" {
  user = aws_iam_user.entraidrolemanager.name
  policy_arn = aws_iam_policy.entraid_ssouserrole_policy.arn
}
