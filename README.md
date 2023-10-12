# Terraform Module: Scaled Compute for AWS

> This directory manages AWS Auto Scaling Groups and associated resources.

## Table of Contents

<!-- TOC -->
* [Terraform Module: Scaled Compute for AWS](#terraform-module-scaled-compute-for-aws)
  * [Table of Contents](#table-of-contents)
  * [Requirements](#requirements)
  * [Usage](#usage)
    * [Inputs](#inputs)
    * [Outputs](#outputs)
  * [Author Information](#author-information)
  * [License](#license)
<!-- TOC -->

## Requirements

* Amazon Web Services (AWS) [Account](https://aws.amazon.com/account/)
* Terraform `1.6.0` or [newer](https://developer.hashicorp.com/terraform/downloads).

## Usage

<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| ami_id | AMI ID to use for Instances in the Auto Scaling Group. | `string` | yes |
| autoscaling_group_desired_capacity | Desired Number of Instances in the Auto Scaling Group. | `number` | yes |
| autoscaling_group_max_size | Maximum Number of Instances in the Auto Scaling Group. | `number` | yes |
| autoscaling_group_min_size | Minimum Number of Instances in the Auto Scaling Group. | `number` | yes |
| availability_zones | List of Availability Zones for the Auto Scaling Group. | `list(string)` | yes |
| aws_region | AWS Region. | `string` | yes |
| custom_prefix | String to prepend on Resource Names. | `string` | yes |
| custom_suffix | String to append to Resource Names. | `string` | yes |
| iam_instance_profile_arn | ARN of the IAM Instance Profile for Instances of the Auto Scaling Group. | `string` | yes |
| launch_template_block_device_mappings | Block Device Configuration for Instances in Launch Template. | <pre>object({<br>    device_name     = string<br>    ebs_volume_size = number<br>  })</pre> | yes |
| launch_template_instance_type | Type of EC2 Instance in Launch Template. | `string` | yes |
| launch_template_key_name | Name of (Public) Key for Instances in Launch Template. | `string` | yes |
| launch_template_user_data | User Data for Instances in Launch Template. | `string` | yes |
| launch_template_vpc_security_group_ids | List of Security Group IDs for Instances in Launch Template. | `list(string)` | yes |
| security_group_vpc_id | VPC ID of Security Group. | `string` | yes |
| autoscaling_group_force_delete | Toggle to enable Force Deletion of Instances in the Auto Scaling Group. | `bool` | no |
| autoscaling_group_health_check_grace_period | Grace Period for Health Check of the Auto Scaling Group. | `number` | no |
| autoscaling_group_health_check_type | Type of Health Check of the Auto Scaling Group. | `string` | no |
| autoscaling_group_launch_template_version | Version of Launch Template to use for Autoscaling Group. | `string` | no |
| autoscaling_group_termination_policies | Termination Policies of the Auto Scaling Group. | `list(string)` | no |
| launch_template_disable_api_stop | Toggle to enable EC2 Instance Stop Protection. | `bool` | no |
| launch_template_disable_api_termination | Toggle to enable EC2 Instance Termination Protection. | `bool` | no |
| launch_template_ebs_optimized | Toggle to enable starting Instances with optimized EBS. | `bool` | no |
| launch_template_instance_initiated_shutdown_behavior | Shutdown Behavior for Instances in Launch Template. | `string` | no |
| launch_template_metadata_options | Metadata Options for Instances in Launch Template. | <pre>object({<br>    http_endpoint               = string<br>    http_protocol_ipv6          = string<br>    http_put_response_hop_limit = number<br>    http_tokens                 = string<br>    instance_metadata_tags      = string<br>  })</pre> | no |
| launch_template_monitoring | Monitoring for Instances in Launch Template. | <pre>object({<br>    enabled = bool<br>  })</pre> | no |
| launch_template_network_interfaces | Network Interfaces for Instances in Launch Template. | <pre>object({<br>    associate_public_ip_address = bool<br>    delete_on_termination       = bool<br>    description_prefix          = string<br>  })</pre> | no |
| launch_template_tags_instance | Tags for Instances in Launch Template. | `map(string)` | no |
| launch_template_tags_network_interface | Tags for Network interface in Launch Template. | `map(string)` | no |
| launch_template_tags_volume | Tags for Volumes in Launch Template. | `map(string)` | no |
| launch_template_update_default_version | Toggle to update the Default Version of the Launch Template. | `bool` | no |
| placement_group_spread_level | Spread Level of Placement Groups. | `string` | no |

### Outputs

| Name | Description |
|------|-------------|
| aws_autoscaling_group | Exported Attributes for `aws_autoscaling_group`. |
| aws_launch_template | Exported Attributes for `aws_launch_template`. |
| aws_placement_group | Exported Attributes for `aws_placement_group`. |
<!-- END_TF_DOCS -->

## Author Information

This repository is maintained by the contributors listed on [GitHub](https://github.com/ksatirli/terraform-aws-scaled-compute/graphs/contributors).

## License

Licensed under the Apache License, Version 2.0 (the "License").

You may obtain a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an _"AS IS"_ basis, without WARRANTIES or conditions of any kind, either express or implied.

See the License for the specific language governing permissions and limitations under the License.
