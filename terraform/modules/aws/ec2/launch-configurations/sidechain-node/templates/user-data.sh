#!/usr/bin/env bash

yum update -y

yum install git docker wget "Development Tools" gcc -y
yum install /usr/bin/g++ -y
amazon-linux-extras | grep nginx | awk '{print $2}' | xargs -n 1 amazon-linux-extras install

service docker start
chkconfig docker on
usermod -a -G docker ec2-user

mkdir -p /opt/sawtooth
chmod -R 775 /opt/sawtooth
chown ec2-user:ec2-user /opt/sawtooth

runuser -l ec2-user -c "git clone https://github.com/propsproject/sidechain-node.git /opt/sawtooth"

curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "export VALIDATOR_URL=${validator_url}" >> /home/ec2-user/.bashrc
echo "export ETHEREUM_URL=${ethereum_url}" >> /home/ec2-user/.bashrc
echo "export PROPS_TOKEN_CONTRACT_ADDRESS=${props_token_contract_address}" >> /home/ec2-user/.bashrc
echo "export SAWTOOTH_PK=${sawtooth_pk}" >> /home/ec2-user/.bashrc
echo "export ETHERSCAN_API_KEY=${etherscan_api_key}" >> /home/ec2-user/.bashrc
echo "export ETHERSCAN_URL=${etherscan_url}" >> /home/ec2-user/.bashrc
echo "export PROPS_TOKEN_DEPLOYED_BLOCK=${props_token_deployed_block}" >> /home/ec2-user/.bashrc
echo "export ETHEREUM_CONFIRMATION_BLOCKS=${ethereum_confirmation_block}" >> /home/ec2-user/.bashrc
echo "export NETWORK_PRIVATE_KEY=${network_private_key}" >> /home/ec2-user/.bashrc
echo "export NETWORK_PUBLIC_KEY=${network_public_key}" >> /home/ec2-user/.bashrc
curl http://169.254.169.254/latest/meta-data/public-ipv4 | xargs -I {} -n 1 echo "export PUBLIC_IP_ADDRESS={}" >> /home/ec2-user/.bashrc

runuser -l ec2-user -c "docker-compose -f /opt/sawtooth/docker/docker-compose.yaml up"

