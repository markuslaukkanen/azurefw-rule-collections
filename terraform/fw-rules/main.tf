
module "fw_network_rules_spoke_x" {
  source = "../modules/network-rule-collections"  
  providers = {
    azurerm.hub   = azurerm.hub
  }
  network_rules = [
    {
      action = "Allow"
      azure_firewall_name = "test-fw"
      name = format("%s-%s-network-rule-EGRESS", var.project, var.environment)
      priority = 1000
      resource_group_name = "rg-test-fw-westeu"
      rules = [
        {
          destination_addresses = [ "185.40.75.20" ]
          destination_ports = [ "22" ]
          name = "sftp_location_1"
          protocols = [ "TCP" ]
          source_addresses = [ "192.168.50.0/27" ]
        },
        {
          destination_addresses = [ "185.40.76.10" ]
          destination_fqdns = [ "sftp.sld.tld" ]
          destination_ports = [ "22" ]
          name = "sftp_location_2"
          protocols = [ "TCP" ]
          source_addresses = [ "192.168.50.0/27" ] 
        }
      ]
    },
    {
      action = "Allow"
      azure_firewall_name = "test-fw"
      name = format("%s-%s-network-rule-INGRESS", var.project, var.environment)
      priority = 1005
      resource_group_name = "rg-test-fw-westeu"
      rules = [
        {
          destination_addresses = [ "value" ]
          destination_ports = [ "value" ]
          name = "value"
          protocols = [ "value" ]
          source_addresses = [ "value" ]
        }
      ]   
    } 
  ]
}

module "fw_application_rules_project_x" {
  source = "../modules/application-rule-collections"
  providers = {
    azurerm.hub   = azurerm.hub
  }
  application_rules = [
    {
      action = "Allow"
      azure_firewall_name = "test-fw"
      name = format("%s-%s-application-rule-EGRESS", var.project, var.environment)
      priority = 1010
      resource_group_name = "rg-test-fw-westeu"
      rules = [
        {
          name = "Datadog"
          source_addresses = [ "192.168.50.0/27" ]
          target_fqdns = [ "*.agent.datadoghq.eu", "*.logs.datadoghq.eu" ]
          protocols = [
            {
              port = "443"
              type = "Https"
            },
            {
              port = "80"
              type = "Http"
            }
          ]
        },
        {
          fqdn_tags = ["WindowsUpdate"]
          name = "WindowsUpdate"
          source_addresses = ["192.168.50.0/27"]
          protocols = []
        }
      ]
    }
  ]
}