variable "region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-west-2"
}

variable "availability_zones" {
  description = "List of Availability Zones for multi-AZ deployment"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
  
  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "FGCP clusters require exactly 2 Availability Zones."
  }
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "fgt-fgcp-ha"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.20.0.0/24"
}

variable "license_type" {
  description = "License type for FortiGate instances (byol/payg)"
  type        = string
  default     = "payg"
  
  validation {
    condition     = contains(["byol", "payg"], var.license_type)
    error_message = "License type must be either 'byol' or 'payg'."
  }
}

variable "instance_type" {
  description = "EC2 instance type for FortiGate instances"
  type        = string
  default     = "c6i.xlarge"
}

variable "fgt_build" {
  description = "FortiGate firmware build version"
  type        = string
  default     = "build2795"
}
