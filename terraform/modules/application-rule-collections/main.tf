terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.hub]
    }
  }
}

locals {
  application_rule_collection_map = { for application_rule in var.application_rules : application_rule.name => application_rule }
}

resource "azurerm_firewall_application_rule_collection" "spoke_application_rule_collection" {
  provider            = azurerm.hub
  for_each            = local.application_rule_collection_map  
  name                = each.key
  azure_firewall_name = each.value.azure_firewall_name
  resource_group_name = each.value.resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name = rule.value["name"]
      source_addresses = rule.value["source_addresses"]
      target_fqdns = rule.value["target_fqdns"]
      fqdn_tags = rule.value["fqdn_tags"]

      dynamic "protocol" {
        for_each = rule.value.protocols
        content {
          port = protocol.value["port"]
          type = protocol.value["type"] 
        }
      }
    }    
  }
}