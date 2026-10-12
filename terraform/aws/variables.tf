variable "aws_region" {
  description = "Home region for the trail, bucket, and queue."
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS account ID (used in the bucket name and bucket policy)."
  type        = string
}

variable "sentinel_workspace_id" {
  description = "Log Analytics workspace (customer) ID from the Azure stack output 'workspace_id'."
  type        = string
}

# Values published by Microsoft for the OIDC-based Sentinel AWS S3 connector
# (Azure commercial cloud). Verify against current Microsoft documentation
# before applying; Azure Government uses different values.
variable "sentinel_oidc_tenant_id" {
  description = "Microsoft tenant that issues the Sentinel connector's OIDC tokens."
  type        = string
  default     = "33e01921-4d64-4f8c-a055-5bdaffd5e33d"
}

variable "sentinel_oidc_audience" {
  description = "Audience (client ID) for the Sentinel connector's OIDC tokens."
  type        = string
  default     = "api://1462b192-27f7-4cb9-8523-0f4ecb54b47e"
}
