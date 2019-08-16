resource "aws_iam_instance_profile" "sidechain" {
  name = "${var.app_name}${title(var.environment_name)}SidechainInstanceProfile"
  role = "${aws_iam_role.sidechain.name}"
}

resource "aws_iam_role" "sidechain" {
  name = "${var.app_name}${title(var.environment_name)}SidechainRole"
  path = "/"
  assume_role_policy = "${file("${path.module}/policies/role.json")}"
}

data "template_file" "policy_json" {
  template = "${file("${path.module}/policies/policy.json")}"
}

resource "aws_iam_policy" "sidechain_iam_policy" {
  name    = "${title(var.app_name)}${title(var.environment_name)}AssociateAddress"
  policy  = "${data.template_file.policy_json.rendered}"
}

resource "aws_iam_role_policy_attachment" "sidechain_policy_attachment" {
  policy_arn  = "${aws_iam_policy.sidechain_iam_policy.arn}"
  role        = "${aws_iam_role.sidechain.name}"
}

/*
data "template_file" "policy_json" {
  template = "${file("${path.module}/policies/policy.json")}"
}

resource "aws_iam_role_policy "sidechain_role_policy {
  policy = "${data.template_file.policy_json.rendered}"
}
*/
