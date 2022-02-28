variable "prod_access_key" {}

variable "prod_secret_key" {}

variable "test_account_id" {}

variable "test_access_key" {}

variable "test_secret_key" {}

variable "bucket_name" {}

variable "region_name" {
  
  default     = "us-east-1"
}

variable "role_name" {
  
  default     = "EKS-Role1"
}

variable "policy_name" {
 
  default     = "EKS-Policy1"
}

variable "user_name" {
 
  default     = "EKS-User1"
}
