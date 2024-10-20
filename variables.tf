
variable "vpc_cidr_block" {
  type        = string
  description = "To set cidr for vpc"
}

variable "subnet_cidr_block" {
  type        = string
  description = "To set cidr for subnet"
}

variable "availability_zone" {
  type        = string
  description = "To set AWS availability region"
}

variable "env_prefix" {
  type        = string
  description = "Set as dev or prod or qa etc. based on desired environment"
}
