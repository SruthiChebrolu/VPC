provider "aws"{
region = "us-east-2"
}

resource "aws_iam_role" "test_role" {
name = "sruthieks54"

assume_role_policy = jsonencode({
Version = "2012-10-17"
Statement = [
{
Action = "sts:AssumeRole"
Effect = "Allow"
Sid = ""
Principal = {
Service = "eks.amazonaws.com"
}
},
]
}) 
tags = {
tag-key = "tag-value"
}
}


 

resource "aws_iam_role_policy" "test1_policy"{
name = "sruthi_policy"
role = aws_iam_role.test_role.id

policy = jsonencode({
Version = "2012-10-17"
Statement = [
{
Action = [
"eks:Describe*",
]
Effect = "Allow"
Resource = "*"
},
]
})
}
