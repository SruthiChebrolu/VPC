provider "aws"{
region = "us-east-2"
}
resource "aws_iam_role" "test6_role" {
name = "power-users" # Terraform's "jsonencode" function converts a
# Terraform expression result to valid JSON syntax.
assume_role_policy = jsonencode({
Version = "2012-10-17"
Statement = [
{
Action = "sts:AssumeRole"
Effect = "Allow"
Sid = ""
Principal = {
Service = "ec2.amazonaws.com"
}
},
]
}) 
tags = {
tag-key = "tag-value"
}
}
resource "aws_iam_role_policy" "test3_policy" {
name = "power-users-policy"
role = aws_iam_role.test6_role.id 
# Terraform's "jsonencode" function converts a
# Terraform expression result to valid JSON syntax.
policy = jsonencode({
Version = "2012-10-17"
Statement = [
{
Action = [
"ec2:Describe*",
]
Effect = "Allow"
Resource = "*"
},
{
"Effect": "Allow",
"Action": [
"s3:Get*",
"s3:List*",
"s3-object-lambda:Get*",
"s3-object-lambda:List*"
],
"Resource": "*"
},
{
"Action": [
"autoscaling:Describe*",
"cloudwatch:Describe*",
"cloudwatch:Get*",
"cloudwatch:List*",
"logs:Get*",
"logs:List*",
"logs:StartQuery",
"logs:StopQuery",
"logs:Describe*",
"logs:TestMetricFilter",
"logs:FilterLogEvents",
"sns:Get*",
"sns:List*"
],
"Effect": "Allow",
"Resource": "*"
},
{
"Effect": "Allow",
"Action": [
"ebs:ListSnapshotBlocks",
"ebs:ListChangedBlocks",
"ebs:GetSnapshotBlock"
],
"Resource": "*"
},
{
"Action": [
"codebuild:BatchGet*",
"codebuild:GetResourcePolicy",
"codebuild:List*",
"codebuild:DescribeTestCases",
"codebuild:DescribeCodeCoverages",
"codecommit:GetBranch",
"codecommit:GetCommit",
"codecommit:GetRepository",
"cloudwatch:GetMetricStatistics",
"events:DescribeRule",
"events:ListTargetsByRule",
"events:ListRuleNamesByTarget",
"logs:GetLogEvents"
],
"Effect": "Allow",
"Resource": "*"
},
{
"Effect": "Allow",
"Action": "autoscaling:Describe*",
"Resource": "*"
},
{
"Action": [
"resource-groups:GetGroupQuery",
"resource-groups:GetGroup",
"resource-groups:GetGroupConfiguration",
"resource-groups:GetTags"
],
"Effect": "Allow",
"Resource": "*",
} ]
})
}

