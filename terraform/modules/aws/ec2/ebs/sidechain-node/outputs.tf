output "id" {
  value = "${aws_ebs_volume.kubernetes.id}"
}

output "arn" {
  value = "${aws_ebs_volume.kubernetes.arn}"
}

output "dlm_filter" {
  value = "${var.environment_name}-${var.app_name}-${var.service_name}"
}