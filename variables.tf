variable "prefix" {
  description = "Objects prefix"
  type        = string
  default     = "fgt-cluster"
}

variable "tags" {
  description = "value of tags"
  type        = map(string)
  default = {
    Project = "ftnt_modules_aws"
  }
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "azs" {
  description = "AWS access key"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "admin_port" {
  description = "value of admin_port"
  type        = string
  default     = "8443"
}

variable "admin_cidr" {
  description = "value of admin_cidr"
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  description = "value of api_token"
  type        = string
  default     = "c6i.large"
}

variable "fgt_build" {
  description = "value of FortiOS build"
  type        = string
  default     = "build2795"
}

variable "license_type" {
  description = "value of license_type"
  type        = string
  default     = "payg"
}

variable "fgt_number_peer_az" {
  description = "value of fgt_number_peer_az"
  type        = number
  default     = 1
}

variable "fgt_cluster_type" {
  description = "value of fgt_cluster_type"
  type        = string
  default     = "fgcp"
}

variable "subnet_tags" {
  description = "map tags used in fgt_subnet_tags to tag subnet names"
  type        = map(string)
  default     = null
}

variable "fgt_subnet_tags" {
  description = <<EOF
      fgt_subnet_tags -> add tags to FGT subnets (port1, port2, public, private ...)
        - leave blank or don't add elements to not create a ports
        - FGCP type of cluster requires a management port
        - port1 must have Internet access in terms of validate license in case of using FortiFlex token or lic file.
    EOF
  type        = map(string)
  default     = null
}

variable "public_subnet_names_extra" {
  description = "VPC - list of additional public subnet names"
  type        = list(string)
  default     = ["bastion"]
}

variable "private_subnet_names_extra" {
  description = "VPC - list of additional private subnet names"
  type        = list(string)
  default     = ["tgw"]
}

variable "fgt_vpc_cidr" {
  description = "VPC - CIDR"
  type        = string
  default     = "10.1.0.0/24"
}

variable "inspection_vpc_cidrs" {
  description = "list of CIDRs for inspection (used in GWLB)"
  type        = list(string)
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "config_gwlb" {
  description = "Boolean to enable deploymen of and GWLB"
  type        = bool
  default     = false
}

variable "fgt_api_key" {
  description = "API key for FGTs"
  type        = string
  default     = null
}


#-----------------------------------------------------------------------------------
# Predefined variables for SPOKE SDWAN
# - config_spoke = false
#-----------------------------------------------------------------------------------
variable "config_spoke" {
  description = "Boolean varible to configure fortigate as SDWAN spoke"
  type        = bool
  default     = false
}

variable "spoke" {
  description = "Default parameters for a site"
  type = object({
    id      = optional(string, "spoke")
    cidr    = optional(string, "10.0.0.0/24")
    bgp_asn = optional(string, "65000")
  })
  default = {}
}

variable "hubs" {
  description = "Details to crate VPN connections and SDWAN config"
  type = list(object({
    id                = optional(string, "HUB")
    bgp_asn           = optional(string, "65000")
    external_ip       = optional(string, "") // leave in blank if use external_fqdn   
    external_fqdn     = optional(string, "") // leave in blank if use external_ip
    hub_ip            = optional(string, "172.16.0.1")
    site_ip           = optional(string, "")
    hck_ip            = optional(string, "172.16.0.1")
    vpn_psk           = optional(string, "secret-key-123")
    cidr              = optional(string, "10.0.0.0/8") // CIRD to be reach throught HUB
    ike_version       = optional(string, "2")
    network_id        = optional(string, "1")
    dpd_retryinterval = optional(string, "5")
    sdwan_port        = optional(string, "public")
  }))
  default = []
}

#-----------------------------------------------------------------------------------
# Predefined variables for HUB
# - config_hub   = false (default) 
#-----------------------------------------------------------------------------------
variable "config_hub" {
  description = "Boolean varible to configure fortigate as a SDWAN HUB"
  type        = bool
  default     = false
}

variable "hub" {
  description = "Map of string with details to create VPN HUB"
  type = list(object({
    id                = optional(string, "HUB")
    bgp_asn_hub       = optional(string, "65000")
    bgp_asn_spoke     = optional(string, "65000")
    vpn_cidr          = optional(string, "172.16.0.0/24")
    vpn_psk           = optional(string, "secret-key-123")
    cidr              = optional(string, "10.0.0.0/8") // network to be announces by BGP to peers
    ike_version       = optional(string, "2")
    network_id        = optional(string, "1")
    dpd_retryinterval = optional(string, "5")
    mode_cfg          = optional(string, true)
    vpn_port          = optional(string, "public")
  }))
  default = []
}