#!/usr/bin/env bash

yum update -y

yum install git docker wget "Development Tools" gcc jq -y
yum install /usr/bin/g++ -y
amazon-linux-extras | grep nginx | awk '{print $2}' | xargs -n 1 amazon-linux-extras install

service docker start
chkconfig docker on
usermod -a -G docker ec2-user

mkdir -p /opt/sawtooth
chmod -R 775 /opt/sawtooth
chown ec2-user:ec2-user /opt/sawtooth

runuser -l ec2-user -c "git clone https://github.com/propsproject/sidechain-node.git /opt/sawtooth"

INSTANCE_ID=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id`

ALLOCATION_ID=`aws ec2 describe-addresses --region us-east-1 --filters="Name=tag:Environment,Values=${environment},Name=tag:App,Values=${app_name}" | jq -r '.Addresses[] | "\(.InstanceId) \(.AllocationId)"' | grep null | awk '{print $2}' | xargs shuf -n1 -e`

if [ ! -z $ALLOCATION_ID ]; then
    aws ec2 associate-address --region us-east-1 --instance-id $INSTANCE_ID --allocation-id $ALLOCATION_ID --allow-reassociation
fi

curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "export VALIDATOR_URL=${validator_url}" >> /home/ec2-user/.bashrc
echo "export ETHEREUM_URL_ETHSYNC=${ethereum_url}" >> /home/ec2-user/.bashrc
echo "export PROPS_TOKEN_CONTRACT_ADDRESS=${props_token_contract_address}" >> /home/ec2-user/.bashrc
echo "export SAWTOOTH_PK=${sawtooth_pk}" >> /home/ec2-user/.bashrc
echo "export ETHERSCAN_API_KEY=${etherscan_api_key}" >> /home/ec2-user/.bashrc
echo "export ETHERSCAN_URL=${etherscan_url}" >> /home/ec2-user/.bashrc
echo "export PROPS_TOKEN_DEPLOYED_BLOCK=${props_token_deployed_block}" >> /home/ec2-user/.bashrc
echo "export ETHEREUM_CONFIRMATION_BLOCKS=${ethereum_confirmation_block}" >> /home/ec2-user/.bashrc
echo "export NETWORK_PRIVATE_KEY=${network_private_key}" >> /home/ec2-user/.bashrc
echo "export NETWORK_PUBLIC_KEY=${network_public_key}" >> /home/ec2-user/.bashrc
echo "export ENVIRONMENT=${environment}" >> /home/ec2-user/.bashrc
echo "export SECONDS_IN_DAY=${seconds_in_day}" >> /home/ec2-user/.bashrc
echo "export NODE_ENV=${environment}" >> /home/ec2-user/.bashrc
echo "export REWARDS_START_TIMESTAMP=${rewards_start_timestamp}" >> /home/ec2-user/.bashrc
echo "export SAWTOOTH_REST_URL=${sawtooth_rest_url}" >> /home/ec2-user/.bashrc
echo "export SAWTOOTH_REST_PORT=${sawtooth_rest_port}" >> /home/ec2-user/.bashrc
echo "export VALIDATOR_SEED_URL=${validator_seed_url}" >> /home/ec2-user/.bashrc
echo "export VALIDATOR_SUBMISSION_PK=${validator_submission_pk}" >> /home/ec2-user/.bashrc
echo "export SAWTOOTH_REST_HTTPS=${sawtooth_rest_https}" >> /home/ec2-user/.bashrc
echo "export STATE_API_URI=${state_api_url}" >> /home/ec2-user/.bashrc
echo "export OPENTSDB_PASSWORD=${opentsdb_password}" >> /home/ec2-user/.bashrc

PUBLIC_IP=`aws ec2 describe-addresses --region us-east-1 --allocation-ids $ALLOCATION_ID | jq -r '.Addresses[0].PublicIp'`
echo "export PUBLIC_IP_ADDRESS=$PUBLIC_IP" >> /home/ec2-user/.bashrc

SAWTOOTH_HOME='/etc/sawtooth'

curl -L "https://raw.githubusercontent.com/propsproject/propschain-node/master/terraform/environments/${environment}-fullnode/network/peers" -o $SAWTOOTH_HOME/peers
sed -i "s+tcp://$PUBLIC_IP_ADDRESS:8800,++g" $SAWTOOTH_HOME/peers
sed -i "s+tcp://$PUBLIC_IP_ADDRESS:8800++g" $SAWTOOTH_HOME/peers

PEERS_STR=$(cat $SAWTOOTH_HOME/peers)
echo "export VALIDATOR_SEED_URL=$PEERS_STR" >> /home/ec2-user/.bashrc



if [ ! -e "$SAWTOOTH_HOME/logs" ]; then
    mkdir -p $SAWTOOTH_HOME/logs
fi

if [ ! -e "$SAWTOOTH_HOME/keys" ]; then
    mkdir -p $SAWTOOTH_HOME/keys
fi

if [ ! -e "$SAWTOOTH_HOME/policy" ]; then
    mkdir -p $SAWTOOTH_HOME/policy
fi

if [ ! -e "$SAWTOOTH_HOME/data" ]; then
    mkdir -p $SAWTOOTH_HOME/data
fi

if [ ! -e "$SAWTOOTH_HOME/etc" ]; then
    mkdir -p $SAWTOOTH_HOME/etc
fi

chmod -R 775 /etc/sawtooth
chown ec2-user:ec2-user /etc/sawtooth -R

runuser -l ec2-user -c "docker-compose -f /opt/sawtooth/docker/${which_docker_compose}/docker-compose.yaml up -d"


