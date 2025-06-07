variable "region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-west-2"
}

variable "availability_zones" {
  description = "List of Availability Zones for FGSP deployment"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
  
  validation {
    condition     = length(var.availability_zones) >= 2 && length(var.availability_zones) <= 4
    error_message = "FGSP clusters support 2-4 Availability Zones."
  }
}

variable "fgt_per_az" {
  description = "Number of FortiGate instances per Availability Zone"
  type        = number
  default     = 1
  
  validation {
    condition     = var.fgt_per_az >= 1 && var.fgt_per_az <= 4
    error_message = "Number of FortiGates per AZ must be between 1 and 4."
  }
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "fgt-fgsp-gwlb"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (larger CIDR needed for multiple AZs)"
  type        = string
  default     = "10.30.0.0/23"
}

variable "license_type" {
  description = "License type for FortiGate instances (byol/payg)"
  type        = string
  default     = "byol"
  
  validation {
    condition     = contains(["byol", "payg"], var.license_type)
    error_message = "License type must be either 'byol' or 'payg'."
  }
}

variable "instance_type" {
  description = "EC2 instance type for FortiGate instances"
  type        = string
  default     = "c6i.large"
}

variable "fgt_build" {
  description = "FortiGate firmware build version"
  type        = string
  default     = "build2795"
}
