output "resource_group_name" {
  value = azurerm_resource_group.sentinel.name
}

output "workspace_name" {
  value = azurerm_log_analytics_workspace.sentinel.name
}

output "workspace_id" {
  description = "Log Analytics workspace (customer) ID. The AWS stack needs this for the Sentinel connector role's trust policy."
  value       = azurerm_log_analytics_workspace.sentinel.workspace_id
}

output "workspace_resource_id" {
  value = azurerm_log_analytics_workspace.sentinel.id
}
