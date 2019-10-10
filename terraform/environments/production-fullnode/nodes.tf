

module "full_node" {
  source = "../../modules/aws/ec2/launch-configurations/propschain-node"

  node_name           = "full-node"
  node_type           = "full-node"
  app_name            = "${var.app_name}"
  environment_name    = "${var.environment_name}"
  key_name            = "${var.key_name}"
  volume_size_gb      = "${var.instance_disk_size}"
  vpc_id              = "${var.vpc_id}"
  ami                 = "${var.ami}"
  subnet_ids          = "${var.subnet_ids}"
  availability_zones  = "${var.aws_availability_zones}"
  instance_type       = "${var.instance_type}"

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

  ethereum_confirmation_block   = "${var.ethereum_confirmation_block}"
  etherscan_api_key             = "${var.etherscan_api_key}"
  etherscan_url                 = "${var.etherscan_url}"
  network_private_key           = "${var.network_private_key}"
  network_public_key            = "${var.network_public_key}"
  props_token_deployed_block    = "${var.props_token_deployed_block}"
  validator_seed_url            = "${var.validator_seed_url}"
  validator_url                 = "${var.validator_url}"
  state_api_url                 = ""
  opentsdb_password             = "${var.opentsdb_password}"

  sawtooth_pk                   = "${var.sawtooth_pk_fullnode}"
  sawtooth_pub                  = "${var.sawtooth_pub_fullnode}"
  use_ebs                       = true // create an EBS volume and use it
  ebs_backup                    = true
  genesis_batch                 = true // create genesis batch and use it
}

module "simple_nodes" {
  source = "../../modules/aws/ec2/launch-configurations/propschain-node"

  node_name           = "simple_node"
  node_type           = "node-only"
  app_name            = "${var.app_name}"
  environment_name    = "${var.environment_name}"
  key_name            = "${var.key_name}"
  volume_size_gb      = "${var.instance_disk_size}"
  vpc_id              = "${var.vpc_id}"
  ami                 = "${var.ami}"
  subnet_ids          = "${var.subnet_ids}"
  availability_zones  = "${var.aws_availability_zones}"
  instance_type       = "${var.instance_type}"
  desired_capacity    = "4"
  min_size            = "4"
  max_size            = "4"

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

  ethereum_confirmation_block   = "${var.ethereum_confirmation_block}"
  etherscan_api_key             = "${var.etherscan_api_key}"
  etherscan_url                 = "${var.etherscan_url}"
  network_private_key           = "${var.network_private_key}"
  network_public_key            = "${var.network_public_key}"
  props_token_deployed_block    = "${var.props_token_deployed_block}"
  validator_seed_url            = "${var.validator_seed_url}"
  validator_url                 = "${var.validator_url}"
  state_api_url                 = ""
  opentsdb_password             = "${var.opentsdb_password}"

  sawtooth_pk                   = "${var.sawtooth_pk_node1}"
  sawtooth_pub                  = "${var.sawtooth_pub_node1}"
  use_ebs                       = false // create an EBS volume and use it
  genesis_batch                 = false // create genesis batch and use it
}

// ---------------------------------------------------------------------------------------------------------------------
//  Create a log group 'sawtooth-logs'
// ---------------------------------------------------------------------------------------------------------------------
module "validator-logs" {
  source = "../../modules/aws/cloudwatch"
  logs_name           = "${var.app_name}-${var.environment_name}-sawtooth-logs"  
}
