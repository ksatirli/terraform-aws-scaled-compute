# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
resource "aws_launch_template" "main" {
  block_device_mappings {
    device_name = var.launch_template_block_device_mappings.device_name

    ebs {
      volume_size = var.launch_template_block_device_mappings.ebs_volume_size
    }
  }

  disable_api_stop        = var.launch_template_disable_api_stop
  disable_api_termination = var.launch_template_disable_api_termination

  ebs_optimized = var.launch_template_ebs_optimized

  image_id = var.launch_template_image_id

  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#instance-profile
  iam_instance_profile {
    arn = var.iam_instance_profile_arn
  }

  instance_initiated_shutdown_behavior = var.launch_template_instance_initiated_shutdown_behavior
  instance_type                        = var.launch_template_instance_type

  name = local.default_name

  key_name = var.launch_template_key_name

  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#metadata-options
  metadata_options {
    http_endpoint               = var.launch_template_metadata_options.http_endpoint
    http_protocol_ipv6          = var.launch_template_metadata_options.http_protocol_ipv6
    http_put_response_hop_limit = var.launch_template_metadata_options.http_put_response_hop_limit
    http_tokens                 = var.launch_template_metadata_options.http_tokens
    instance_metadata_tags      = var.launch_template_metadata_options.instance_metadata_tags
  }

  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#monitoring
  monitoring {
    enabled = var.launch_template_monitoring.enabled
  }

  # TODO: investigate if this is needed for compute
  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#network-interfaces
  # network_interfaces {
  #  associate_public_ip_address = var.launch_template_network_interfaces.associate_public_ip_address
  #  delete_on_termination       = var.launch_template_network_interfaces.delete_on_termination
  #  description                 = local.launch_template_network_interfaces_description
  # }

  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#tag-specifications
  tag_specifications {
    resource_type = "instance"

    # see https://developer.hashicorp.com/terraform/language/functions/merge
    tags = merge({
      # see https://developer.hashicorp.com/terraform/language/functions/replace
      "Name" = local.default_name
    }, var.launch_template_tags_instance)
  }

  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#tag-specifications
  tag_specifications {
    resource_type = "network-interface"

    # see https://developer.hashicorp.com/terraform/language/functions/merge
    tags = merge({
      # see https://developer.hashicorp.com/terraform/language/functions/replace
      "Name" = local.default_name
    }, var.launch_template_tags_network_interface)
  }

  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#tag-specifications
  tag_specifications {
    resource_type = "volume"

    # see https://developer.hashicorp.com/terraform/language/functions/merge
    tags = merge({
      # see https://developer.hashicorp.com/terraform/language/functions/replace
      "Name" = local.default_name
    }, var.launch_template_tags_volume)
  }

  update_default_version = var.launch_template_update_default_version
  user_data              = var.launch_template_user_data

  vpc_security_group_ids = var.launch_template_vpc_security_group_ids
}

# see https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html
# and https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/placement_group
resource "aws_placement_group" "main" {
  name = local.default_name

  #partition_count = var.placement_group_partition_count
  spread_level = var.placement_group_spread_level

  # The `Spread` Strategy places instances on distinct hardware
  # see https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html#placement-groups-spread
  # and https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html#placement-groups-limitations-spread
  strategy = "spread"
}

# see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
resource "aws_autoscaling_group" "main" {
  # assemble name consisting of user-defined prefix, availability zone and random suffix
  name = local.default_name

  availability_zones = var.availability_zones

  desired_capacity = var.autoscaling_group_desired_capacity

  # TODO
  enabled_metrics = []

  force_delete              = var.autoscaling_group_force_delete
  health_check_grace_period = var.autoscaling_group_health_check_grace_period
  health_check_type         = var.autoscaling_group_health_check_type

  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#launch_template
  launch_template {
    id      = aws_launch_template.main.id
    version = var.autoscaling_group_launch_template_version
  }

  max_size = var.autoscaling_group_max_size
  min_size = var.autoscaling_group_min_size

  placement_group = aws_placement_group.main.id

  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#termination_policies
  termination_policies = var.autoscaling_group_termination_policies

  # see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#timeouts
  timeouts {
    delete = "15m"
  }
}
