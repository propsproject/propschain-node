resource "aws_ebs_volume" "sidechain_node" {
  availability_zone = "${element(split(",", var.availability_zones), 0)}"
  size              = "${var.size}"
  type              = "${var.type}"
  snapshot_id       = "${var.snapshot_id}"

  tags {
    Name              = "${var.environment_name}-${var.app_name}-${var.service_name} - EBS"
    App               = "${var.app_name}"
    Environment       = "${var.environment_name}"
    Service           = "${var.service_name}"
    KubernetesCluster = "${var.k8s_name}"
    DlmFilter         = "${var.environment_name}-${var.app_name}-${var.service_name}"
  }
}

