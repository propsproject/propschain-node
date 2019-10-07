resource "aws_cloudwatch_log_group" "sawtooth-logs" {
  name = "${var.logs_name}"
}
