resource "aws_iam_instance_profile" "sidechain" {
  name = "${var.app_name}${title(var.environment_name)}SidechainInstanceProfile"
  role = "${aws_iam_role.sidechain.name}"
}

resource "aws_iam_role" "sidechain" {
  name = "${var.app_name}${title(var.environment_name)}SidechainRole"
  path = "/"
  assume_role_policy = "${file("${path.module}/policies/role.json")}"
}
