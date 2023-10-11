output "aws_autoscaling_group" {
  description = "Exported Attributes for `aws_autoscaling_group`."
  value       = aws_autoscaling_group.main
}

output "aws_launch_template" {
  description = "Exported Attributes for `aws_launch_template`."
  value       = aws_launch_template.main
}

output "aws_placement_group" {
  description = "Exported Attributes for `aws_placement_group`."
  value       = aws_placement_group.main
}
