# Scheduled analytics rules. Sentinel validates each query against the
# workspace when the rule is created, so a rule that references a table
# with no data yet will fail. That is why each group sits behind a flag:
# deploy the workspace first, confirm data is flowing, then flip the flag.

locals {
  detections_path = "${path.module}/../../detections"

  entra_rules = {
    "password-spray" = {
      display_name = "GB - Password spray against Entra ID"
      severity     = "Medium"
      file         = "01-password-spray.kql"
      frequency    = "PT1H"
      period       = "PT1H"
      tactics      = ["CredentialAccess"]
    }
    "pim-activation" = {
      display_name = "GB - Privileged role activated through PIM"
      severity     = "Informational"
      file         = "02-pim-activation.kql"
      frequency    = "PT1H"
      period       = "PT1H"
      tactics      = ["PrivilegeEscalation"]
    }
    "role-assigned-outside-pim" = {
      display_name = "GB - Entra role assigned outside of PIM"
      severity     = "High"
      file         = "03-role-assigned-outside-pim.kql"
      frequency    = "PT1H"
      period       = "PT1H"
      tactics      = ["PrivilegeEscalation", "Persistence"]
    }
  }

  aws_rules = {
    "aws-iam-user-outside-identity-center" = {
      display_name = "GB - AWS IAM user created outside Identity Center"
      severity     = "Medium"
      file         = "04-aws-iam-user-outside-identity-center.kql"
      frequency    = "PT1H"
      period       = "PT1H"
      tactics      = ["Persistence"]
    }
    "aws-console-login-after-entra-disable" = {
      display_name = "GB - AWS console sign-in after Entra account disabled"
      severity     = "High"
      file         = "05-aws-console-login-after-entra-disable.kql"
      frequency    = "PT1H"
      period       = "P1D"
      tactics      = ["InitialAccess"]
    }
  }
}

resource "azurerm_sentinel_alert_rule_scheduled" "entra" {
  for_each = var.deploy_entra_rules ? local.entra_rules : {}

  name                       = "gavinbarbee-${each.key}"
  log_analytics_workspace_id = azurerm_sentinel_log_analytics_workspace_onboarding.sentinel.workspace_id
  display_name               = each.value.display_name
  severity                   = each.value.severity
  query                      = file("${local.detections_path}/${each.value.file}")
  query_frequency            = each.value.frequency
  query_period               = each.value.period
  trigger_operator           = "GreaterThan"
  trigger_threshold          = 0
  tactics                    = each.value.tactics
}

resource "azurerm_sentinel_alert_rule_scheduled" "aws" {
  for_each = var.deploy_aws_rules ? local.aws_rules : {}

  name                       = "gavinbarbee-${each.key}"
  log_analytics_workspace_id = azurerm_sentinel_log_analytics_workspace_onboarding.sentinel.workspace_id
  display_name               = each.value.display_name
  severity                   = each.value.severity
  query                      = file("${local.detections_path}/${each.value.file}")
  query_frequency            = each.value.frequency
  query_period               = each.value.period
  trigger_operator           = "GreaterThan"
  trigger_threshold          = 0
  tactics                    = each.value.tactics
}
