variable "network_rules" {
  description = "Network rule collection fw rules."
  type = list(object({
    name                = string
    azure_firewall_name = string
    resource_group_name = string
    priority            = number
    action              = string
    rules = list(object({
      name = string
      source_addresses = list(string)
      destination_ports = list(string)
      destination_addresses = list(string)
      destination_fqdns = optional(list(string), []) # DNS proxy must be enabled on FW
      protocols = list(string) }
    ))
  }))
}
