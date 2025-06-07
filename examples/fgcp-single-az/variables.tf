variable "region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-west-2"
}

variable "availability_zone" {
  description = "Availability Zone for single AZ deployment"
  type        = string
  default     = "us-west-2a"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "fgt-fgcp-1az"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/24"
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
