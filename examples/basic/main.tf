module "basic" {
  source = "../.."

  autoscaling_group_desired_capacity = 3
  autoscaling_group_max_size         = 3
  autoscaling_group_min_size         = 1

  aws_region = "us-east-1"

  availability_zones = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]

  launch_template_block_device_mappings = {
    # root device for Ubuntu 22.04 LTS
    device_name     = "/dev/sda1"
    ebs_volume_size = 50 # size in GB
  }

  launch_template_image_id = data.aws_ami.main.image_id
  launch_template_instance_type = "t2.micro"
  launch_template_key_name = "basic"
  launch_template_user_data     = "exit 0"

  custom_prefix = "basic"
  custom_suffix = "basic"
}
