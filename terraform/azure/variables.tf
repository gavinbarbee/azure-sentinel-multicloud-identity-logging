variable "subscription_id" {
  description = "Azure subscription that hosts the Sentinel workspace (must be in the same tenant as the Entra ID logs)."
  type        = string
}

variable "location" {
  description = "Azure region for the workspace."
  type        = string
  default     = "eastus2"
}

variable "daily_quota_gb" {
  description = "Daily ingestion cap for the workspace, so a lab can never run up a surprise bill."
  type        = number
  default     = 1
}

variable "retention_in_days" {
  description = "Log retention in the workspace."
  type        = number
  default     = 90
}

variable "deploy_entra_rules" {
  description = "Deploy the Entra ID analytics rules. Leave false until SigninLogs and AuditLogs contain data."
  type        = bool
  default     = false
}

variable "deploy_aws_rules" {
  description = "Deploy the AWS analytics rules. Leave false until the AWSCloudTrail table contains data."
  type        = bool
  default     = false
}
