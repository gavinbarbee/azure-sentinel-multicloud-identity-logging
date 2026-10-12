locals {
  tags = {
    project     = "sentinel-multicloud-identity-logging"
    owner       = "gavinbarbee"
    environment = "lab"
  }
}

resource "azurerm_resource_group" "sentinel" {
  name     = "rg-gavinbarbee-sentinel"
  location = var.location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "sentinel" {
  name                = "log-gavinbarbee-sentinel"
  location            = azurerm_resource_group.sentinel.location
  resource_group_name = azurerm_resource_group.sentinel.name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_in_days
  daily_quota_gb      = var.daily_quota_gb
  tags                = local.tags
}

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  workspace_id = azurerm_log_analytics_workspace.sentinel.id
}
