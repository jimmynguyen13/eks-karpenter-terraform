variable "private_subnets" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}

variable "instance_type" {
  description = "Default instance type for nodegroup"
  type        = string
  default     = "t3.small"
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}