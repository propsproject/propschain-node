module "security_group" {
  source = "../../security-groups/sidechain-node"

  app_name          = "${var.app_name}"
  environment_name  = "${var.environment_name}"
  vpc_id            = "${var.vpc_id}"
}

module "policy" {
  source = "../../../iam/sidechain-node"

  app_name          = "${var.app_name}"
  environment_name  = "${var.environment_name}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user-data.sh")}"

  vars = {
    environment                   = "${var.environment_name}"
    ethereum_url                  = "${var.ethereum_url}"
    props_token_contract_address  = "${var.props_token_contract_address}"
    validator_submission_pk       = "${var.validator_submission_pk}"
    which_docker_compose          = "${var.which_docker_compose}"
  }
}

resource "aws_launch_configuration" "sidechain_lc" {
  name_prefix   = "${var.app_name}-${var.environment_name}-lc"
  image_id      = "${var.ami}"
  instance_type = "${var.instance_type}"
  user_data     = "${data.template_file.user_data.rendered}"

  security_groups = ["${module.security_group.id}"]

  iam_instance_profile        = "${module.policy.profile_id}"
  associate_public_ip_address = true
  key_name                    = "${var.key_name}"

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = "${var.volume_size_gb}"
  }
}

resource "aws_autoscaling_group" "sidechain_asg" {
  name = "${var.app_name}-${var.environment_name}-asg"

  vpc_zone_identifier       = "${split(",", var.subnet_ids)}"

  desired_capacity          = "${var.desired_capacity}"
  min_size                  = "${var.min_size}"
  max_size                  = "${var.max_size}"
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_configuration      = "${aws_launch_configuration.sidechain_lc.name}"

  tag {
    key                 = "Name"
    value               = "${var.app_name}-${var.environment_name}-asg"
    propagate_at_launch = true
  }

  tag {
    key = "Environment"
    value = "${var.environment_name}"
    propagate_at_launch = true
  }

  tag {
    key = "App"
    value = "${var.app_name}"
    propagate_at_launch = true
  }

  tag {
    key = "Role"
    value = "Sidechain"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
