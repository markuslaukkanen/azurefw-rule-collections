variable "application_rules" {
  description = "Application rule collection fw rules."
  type = list(object({
    name                = string
    azure_firewall_name = string
    resource_group_name = string
    priority            = number
    action              = string
    rules = list(object({
      name = string
      target_fqdns = optional(list(string), [])
      source_addresses = list(string)
      fqdn_tags = optional(list(string), []) 
      protocols = list(object({
        port = string
        type = string  
      })) 
    }))
  }))
}