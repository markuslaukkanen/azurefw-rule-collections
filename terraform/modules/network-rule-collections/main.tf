terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.hub]
    }
  }
}

locals {
  network_rule_map         = { for network_rule in var.network_rules : network_rule.name => network_rule }
}

resource "azurerm_firewall_network_rule_collection" "spoke_network_rule_collection" {
  provider            = azurerm.hub
  for_each            = local.network_rule_map  
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
      destination_ports = rule.value["destination_ports"]
      destination_addresses = rule.value["destination_addresses"]
      destination_fqdns = rule.value["destination_fqdns"]
      protocols = rule.value["protocols"]
    }
  }
}
