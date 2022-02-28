provider "aws" {
  alias = "prod"

  region     = var.region_name
  access_key = "${var.prod_access_key}"
  secret_key = "${var.prod_secret_key}"
}

#Creation policy for role
resource "aws_iam_role_policy" "test" {
provider = "aws.prod"
  name = var.policy_name
  role = aws_iam_role.role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:CreateBucket",
                "s3:ListBucket",
		"s3:ListAllMyBuckets",
                "s3:DeleteObject",
                "s3:DeleteBucket"
            ],
            "Resource": "*"
    }
  ]   
  })
}



#creation of role

resource "aws_iam_role" "role" {
  name = var.role_name

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.test_account_id}:root"
            },
            "Action": "sts:AssumeRole",
            "Condition": {}
        }
    ]
}
EOF
}


resource "aws_s3_bucket" "prod" {
  provider = "aws.prod"

  bucket = "${var.bucket_name}"
 
}

resource "aws_s3_bucket_object" "prod" {
  provider = "aws.prod"

  bucket = "${aws_s3_bucket.prod.id}"
  key    = "object-uploaded-via-prod-creds"
  source = "${path.module}/prod.txt"
}

provider "aws" {
  alias = "test"

  region     = var.region_name
  access_key = "${var.test_access_key}"
  secret_key = "${var.test_secret_key}"
}


resource "aws_iam_user_policy"  "test" {
provider = "aws.test"
  name = var.policy_name
  user = aws_iam_user.user.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "sts:AssumeRole"
            "Resource": "arn:aws:iam::251948964738:role/EKS-Role1"
    }
  ]   
  })
}


resource "aws_iam_user" "user" {
provider = "aws.test"
  name = var.user_name
}


