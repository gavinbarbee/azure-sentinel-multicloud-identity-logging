# Entra ID (tenant-level) logs -> Sentinel workspace.
# Requires Global Administrator or Security Administrator in the tenant,
# and an Entra ID P1/P2 license for sign-in log export.
resource "azurerm_monitor_aad_diagnostic_setting" "entra" {
  name                       = "diag-gavinbarbee-entra-to-sentinel"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.sentinel.id

  enabled_log {
    category = "SignInLogs"
  }

  enabled_log {
    category = "NonInteractiveUserSignInLogs"
  }

  enabled_log {
    category = "ServicePrincipalSignInLogs"
  }

  enabled_log {
    category = "AuditLogs"
  }
}

# Azure subscription Activity Log -> Sentinel workspace.
resource "azurerm_monitor_diagnostic_setting" "activity" {
  name                       = "diag-gavinbarbee-activity-to-sentinel"
  target_resource_id         = "/subscriptions/${var.subscription_id}"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.sentinel.id

  enabled_log {
    category = "Administrative"
  }

  enabled_log {
    category = "Security"
  }

  enabled_log {
    category = "Policy"
  }
}
