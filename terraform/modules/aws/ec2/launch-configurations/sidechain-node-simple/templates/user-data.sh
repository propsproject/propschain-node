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

echo "export ETHEREUM_URL_ETHSYNC=${ethereum_url}" >> /home/ec2-user/.bashrc
echo "export PROPS_TOKEN_CONTRACT_ADDRESS=${props_token_contract_address}" >> /home/ec2-user/.bashrc
echo "export VALIDATOR_SUBMISSION_PK=${validator_submission_pk}" >> /home/ec2-user/.bashrc
echo "export ENVIRONMENT=${environment}" >> /home/ec2-user/.bashrc
echo "export SECONDS_IN_DAY=${seconds_in_day}" >> /home/ec2-user/.bashrc
echo "export NODE_ENV=${environment}" >> /home/ec2-user/.bashrc
echo "export REWARDS_START_TIMESTAMP=${rewards_start_timestamp}" >> /home/ec2-user/.bashrc
echo "export SAWTOOTH_REST_URL=${sawtooth_rest_url}" >> /home/ec2-user/.bashrc
echo "export SAWTOOTH_REST_PORT=${sawtooth_rest_port}" >> /home/ec2-user/.bashrc
echo "export SAWTOOTH_REST_HTTPS=${sawtooth_rest_https}" >> /home/ec2-user/.bashrc

curl http://169.254.169.254/latest/meta-data/public-ipv4 | xargs -I {} -n 1 echo "export PUBLIC_IP_ADDRESS={}" >> /home/ec2-user/.bashrc

croncmd=". \$HOME/.bash_profile; /usr/local/bin/docker-compose -f /opt/sawtooth/docker/${which_docker_compose}/docker-compose.yaml run --entrypoint \"npm run submit-rewards\" eth-sync >> /tmp/rewards.log 2>&1"
cronjob="${frequency_minutes} ${frequency_hours} * * * $croncmd"
( crontab -u ec2-user -l | grep -v "$croncmd" ; echo "$cronjob" ) | crontab -u ec2-user -

runuser -l ec2-user -c "docker-compose -f /opt/sawtooth/docker/${which_docker_compose}/docker-compose.yaml up -d"

