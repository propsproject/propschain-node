module "node1" {
  source = "../../modules/aws/ec2/launch-configurations/sidechain-node-simple"

  app_name            = "${var.app_name}"
  environment_name    = "${var.environment_name}"
  key_name            = "${var.key_name}"
  volume_size_gb      = "${var.instance_disk_size}"
  vpc_id              = "${var.vpc_id}"
  ami                 = "${var.ami}"
  subnet_ids          = "${var.subnet_ids}"
  availability_zones  = "${var.aws_availability_zones}"
  desired_capacity    = "${var.nodes_count}"
  min_size            = "${var.nodes_count}"
  max_size            = "${var.nodes_count}"

  ethereum_url                  = "${var.ethereum_url}"
  props_token_contract_address  = "${var.props_token_contract_address}"
  which_docker_compose          = "${var.which_docker_compose}"
  validator_submission_pk       = "${var.validator_submission_pk}"
  seconds_in_day                = "${var.seconds_in_day}"
  frequency_hours               = "${var.frequency_hours}"
  frequency_minutes             = "${var.frequency_minutes}"
  rewards_start_timestamp       = "${var.rewards_start_timestamp}"
  sawtooth_rest_url             = "${var.sawtooth_rest_url}"
  sawtooth_rest_port            = "${var.sawtooth_rest_port}"
  sawtooth_rest_https           = "${var.sawtooth_rest_https}"
  state_api_url                 = "${var.state_api_url}"
}

output "node_ip" {
  value = "${module.node1.node_ip}"
}
