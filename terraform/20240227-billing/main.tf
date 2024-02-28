terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.38.0"
    }
  }
}

provider "aws" {
  # Configuration options
  profile = "ENPM665"
  region = "us-east-1"
}

resource "aws_iam_group" "billing_full_access_group" {
  name = "BillingFullAccessGroup"
}

resource "aws_iam_user" "finanace_manager" {
  name = "FinanceManager"
}

resource "aws_iam_user_group_membership" "finanace_manager" {
  user = aws_iam_user.finanace_manager.name
  groups = [ aws_iam_group.billing_full_access_group.name ]
}

resource "aws_iam_group_policy_attachment" "billing_full_access_group" {
  group = aws_iam_group.billing_full_access_group.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

resource "aws_iam_group" "billing_view_access_group" {
  name = "BillingViewAccessGroup"
}

resource "aws_iam_user" "finance_user" {
  name = "FinanceUser"
}

resource "aws_iam_user_group_membership" "finance_user" {
  user = aws_iam_user.finance_user.name
  groups = [ aws_iam_group.billing_view_access_group.name ]
}

resource "aws_iam_group_policy_attachment" "name" {
	group = aws_iam_group.billing_view_access_group.name
	policy_arn = "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
}