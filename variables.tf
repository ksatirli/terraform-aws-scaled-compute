variable "autoscaling_group_desired_capacity" {
  type        = number
  description = "Desired Number of Instances in the Auto Scaling Group."
}

variable "autoscaling_group_force_delete" {
  type        = bool
  description = "Toggle to enable Force Deletion of Instances in the Auto Scaling Group."

  # may leave resources dangling (and unmanageable by Terraform)
  default = false
}

variable "autoscaling_group_health_check_grace_period" {
  type        = number
  description = "Grace Period for Health Check of the Auto Scaling Group."
  default     = 300 # value in seconds
}

variable "autoscaling_group_health_check_type" {
  type        = string
  description = "Type of Health Check of the Auto Scaling Group."
  default     = "EC2" # "ELB" or "EC2"
}

variable "autoscaling_group_instance_refresh_preferences" {
  type = object({
    checkpoint_delay             = number
    checkpoint_percentages       = number
    instance_warmup              = number
    min_healthy_percentage       = number
    skip_matching                = bool
    auto_rollback                = bool
    scale_in_protected_instances = string
    standby_instances            = string
  })

  description = "Instance Refresh Strategy of the Auto Scaling Group."

  default = {
    # Number of seconds to wait after checkpoint.
    checkpoint_delay = 3600

    # List of percentages for checkpoint.
    checkpoint_percentages = 100

    # Number of seconds until a newly launched instance is configured and ready to use.
    instance_warmup = 300

    # Capacity in the Auto Scaling group that must remain healthy during an instance refresh
    min_healthy_percentage = 0

    # Replace instances that already have desired Launch Template version.
    skip_matching = false

    # Automatically rollback if Instance Refresh fails
    auto_rollback = false

    # Behavior when encountering Instances protected from scale in are found.
    scale_in_protected_instances = "Ignore"

    # Behavior when encountering instances in the Standby state in are found.
    standby_instances = "Ignore"
  }
}

variable "autoscaling_group_instance_refresh_strategy" {
  type        = string
  description = "Instance Refresh Strategy of the Auto Scaling Group."
  default     = "Rolling"
}

variable "autoscaling_group_instance_refresh_tags" {
  type        = list(string)
  description = "List of Property Names that will trigger an Instance Refresh."

  default = [
    "launch_template"
  ]
}

variable "autoscaling_group_launch_template_version" {
  type        = string
  description = "Version of Launch Template to use for Autoscaling Group."
  default     = "$Latest"
}

variable "autoscaling_group_max_size" {
  type        = number
  description = "Maximum Number of Instances in the Auto Scaling Group."
}

variable "autoscaling_group_min_size" {
  type        = number
  description = "Minimum Number of Instances in the Auto Scaling Group."
}

variable "autoscaling_group_termination_policies" {
  type        = list(string)
  description = "Termination Policies of the Auto Scaling Group."

  # see autoscaling_group_termination_policies
  default = [
    "OldestLaunchConfiguration",
    "OldestLaunchTemplate",
    "OldestInstance",
    "ClosestToNextInstanceHour",
  ]
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones for the Auto Scaling Group."
}

variable "aws_region" {
  type        = string
  description = "AWS Region."
}

variable "custom_prefix" {
  type        = string
  description = "String to prepend on Resource Names."
}

variable "custom_suffix" {
  type        = string
  description = "String to append to Resource Names."
}

locals {
  # assemble "regional default name" from user-supplied prefix, TFC-supplied AWS Region, and a random string
  regional_default_name = "${var.custom_prefix}-%s-${var.custom_suffix}"

  # create sanitized version of "regional default name" by replacing tokens with dash
  default_name = replace(local.regional_default_name, "-%s-", "-")
}

variable "iam_instance_profile_arn" {
  type        = string
  description = "ARN of the IAM Instance Profile for Instances of the Auto Scaling Group."
}

variable "launch_template_block_device_mappings" {
  type = object({
    device_name     = string
    ebs_volume_size = number
  })

  description = "Block Device Configuration for Instances in Launch Template."
}

variable "launch_template_disable_api_stop" {
  type        = bool
  description = "Toggle to enable EC2 Instance Stop Protection."
  default     = true
}

variable "launch_template_disable_api_termination" {
  type        = bool
  description = "Toggle to enable EC2 Instance Termination Protection."
  default     = true
}

variable "launch_template_ebs_optimized" {
  type        = bool
  description = "Toggle to enable starting Instances with optimized EBS."
  default     = false
}

variable "launch_template_image_id" {
  type        = string
  description = "AMI ID to use for Instances in the Auto Scaling Group."
}

variable "launch_template_instance_initiated_shutdown_behavior" {
  type        = string
  description = "Shutdown Behavior for Instances in Launch Template."
  default     = "terminate"
}

variable "launch_template_instance_type" {
  type        = string
  description = "Type of EC2 Instance in Launch Template."

  # intentionally not set to a default value to avoid unintentional deployments
}

variable "launch_template_key_name" {
  type        = string
  description = "Name of (Public) Key for Instances in Launch Template."
}

variable "launch_template_metadata_options" {
  type = object({
    http_endpoint               = string
    http_protocol_ipv6          = string
    http_put_response_hop_limit = number
    http_tokens                 = string
    instance_metadata_tags      = string
  })

  description = "Metadata Options for Instances in Launch Template."

  default = {
    # enables IMDS v1 / v2
    http_endpoint = "enabled"

    # enable IPv6 support for IMDS
    http_protocol_ipv6 = "disabled"

    # Desired HTTP PUT response hop limit for requests.
    http_put_response_hop_limit = 1

    # enables IMDSv2 and requires a token to be passed in the header
    http_tokens = "required"

    # enable access to Instance Tags via IMDS
    instance_metadata_tags = "enabled"
  }
}

variable "launch_template_monitoring" {
  type = object({
    enabled = bool
  })

  description = "Monitoring for Instances in Launch Template."

  default = {
    enabled = true
  }
}

variable "launch_template_network_interfaces" {
  type = object({
    associate_public_ip_address = bool
    delete_on_termination       = bool
    description_prefix          = string
  })

  description = "Network Interfaces for Instances in Launch Template."

  default = {
    associate_public_ip_address = true
    delete_on_termination       = true
    description_prefix          = "Public IP for Instances"
  }
}

locals {
  # `regional_name_client` and `regional_name_server` are processed
  # with the `replace` function and will have `%s` replaced by the AZ
  launch_template_network_interfaces_description = "${var.launch_template_network_interfaces.description_prefix} in ASG `%s`"
}

variable "launch_template_tags_instance" {
  type        = map(string)
  description = "Tags for Instances in Launch Template."

  default = {}
}

variable "launch_template_tags_network_interface" {
  type        = map(string)
  description = "Tags for Network interface in Launch Template."

  default = {}
}

variable "launch_template_tags_volume" {
  type        = map(string)
  description = "Tags for Volumes in Launch Template."

  default = {}
}

variable "launch_template_update_default_version" {
  type        = bool
  description = "Toggle to update the Default Version of the Launch Template."
  default     = true
}

variable "launch_template_user_data" {
  type        = string
  description = "User Data for Instances in Launch Template."
}

variable "launch_template_vpc_security_group_ids" {
  type        = list(string)
  description = "List of Security Group IDs for Instances in Launch Template."
}

#variable "placement_group_partition_count" {
#  type        = number
#  description = "Number of Partitions in the Placement Group."
#  default     = 3
#
#  validation {
#    condition     = var.placement_group_partition_count >= 1 && var.placement_group_partition_count <= 7
#    error_message = "Partition Count must be between `1` and `7`."
#  }
#}

variable "placement_group_spread_level" {
  type        = string
  description = "Spread Level of Placement Groups."
  default     = "rack"
}
