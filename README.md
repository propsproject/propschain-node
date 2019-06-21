# sidechain-node

![Props Token](https://propsproject.com/static/images/main-logo.png)

Everything that is needed to set up a sidechain node that connects to props

WIP: This document is only for our staging node. Production configuration and instructions will come at a later time.

## Description

We are using AWS as our cloud provider, thus we provide you with a terraform setup that allows you to quickly create a launch configuration. This launch configuration creates an instance with a sidechain node.

You're not obligated to use these terraform files, you can use them as a guide to create your own instance on AWS or another cloud provider.

### Folder structure

* ***/docker***: this contains the docker-compose.yaml file that creates the sidechain node. This is all you need if you don't want to use our terraform files
* ***/terraform/environments***: contains folders for each environment (staging, production, etc) with the terraform configuration for each environment 
* ***/terraform/modules***: custom terraform modules

### Requirements

* You need to create a free infura account (https://infura.io/)
* You also need to create an etherscan account and create an API key (https://etherscan.io/myapikey)
 

### Terraform

This step is optional if you want to configure your own instance with docker, but it will make the setup much easier. These terraform files are for AWS. 

If you choose not to use terraform, scroll down and read the section about **docker**.

#### 1. Preparation

Install terraform from https://www.terraform.io/downloads.html

Create a new AWS profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

```
$ aws configure --profile sidechain-staging
``` 

Copy the terraform.tfvars template

```
$ cd terraform/environments/staging
$ cp terraform.tfvars.tmp terraform.tfvars
```

In AWS console create a new key pair (EC2 -> Network & Security -> Key Pairs -> Create Key Pair) and name the key pair ***sawtooth-staging***. You can choose another name if you prefer, but make sure you modify the **key_name** variable in the next step.

#### 2. Configuration for the staging node

Modify the terraform.tfvars file with your settings. We provide you with a couple of default values. Here's an overview of the variables that you might want or will have to change.

Examples are given after each variable

AWS Configuration
* aws_region: the aws region in which you want to spawn the instances. (e.g. **us-east-1**)
* aws_availability_zones: choose the availability zones that for the instances, comma separated. (e.g. **us-east-1a,us-east-1b,us-east-1c**)
* vpc_id: the VPC in which you want to create your instances. The default AWS VPC is always a good starting point. (e.g **vpc-abcdefgh**)
* subnet_ids: the subnets (comma separated) in which you want to create your instances, I suggest taking the default AWS public subnets, (e.g **subnet-abcdefgh,subnet-ijklmnop**)
* ami: this is the AMI that the instance is based of, this is the official amazon linux image for AWS. Don't change this value.

Node configuration
* nodes_count: how many sidechains do you want to launch? (e.g. **1**)
* instance_disk_size: how big should the disk be? 40 is a good starting number (e.g. **40**)
* ethereum_confirmation_block: don't change this value
* ethereum_url: this is the infura url (see requirements above) (e.g. **https://rinkeby.infura.io/v3/yourkeyhere>**)
* etherscan_url: this is the etherscan api url. The default value should be good (e.g. **https://api-rinkeby.etherscan.io/api**)
* etherscan_api_key: this is the etherscan api key, see requirements above
* props_token_contract_address: the address of the props token contract address on rinkeby. The default value is good
* props_token_deployed_block: the blockId of the contract address. The default value is good
* sawtooth_pk: the private key for sawtooth to use, contact us for this key
* validator_url: the default value is good, will need to be removed at some point
* network_private_key: the zeromq private key, you need to contact us for this key
* network_public_key: the zeromq public key, you need to contact us for this key

Once you have modified terraform.tfvars we can now create the instance

#### 3. Terraforming

Initialize terraform

```
$ cd terraform/environments/staging
$ terraform init
```

Create your infrastructure

```
$ terraform apply
```

#### 4. Finishing up and checking your instance

Go into AWS console EC2 and check if your instances are spawning. Depending on your **nodes_count** above you will see 1 or more instances being spawned.

Starting an instance will take some time, but after a couple of minutes they should be up and running. 

Take the IP address of your node and go to 

```
http://<ipaddress>:8008/peers
or
http://<ipaddress>:8008/blocks
```

It will take some time to sync your node, so blocks might not give immediate results

### Docker

If you followed the terraform instructions and built your instance that way, you don't need this section. But it's still useful to read this.

#### 1. Preparation

You need to install docker and docker-compose (https://docs.docker.com/compose)

#### 2. Environment variables

You need the set the following environment variables on your instance

* VALIDATOR_URL=tcp://validator:4004
* ETHEREUM_URL=https://rinkeby.infura.io/v3/<yourkeyhere>
* PROPS_TOKEN_CONTRACT_ADDRESS=0x98f8ab77be1658b398f050338b0c6f3f6c025d4a
* PUBLIC_IP_ADDRESS: This is the public IP address of your instance
* SAWTOOTH_PK: Contact us for this key
* NETWORK_PUBLIC_KEY: Contact us for this key
* NETWORK_PRIVATE_KEY: Contact us for this key
* PROPS_TOKEN_CONTRACT_ADDRESS=0x98f8ab77be1658b398f050338b0c6f3f6c025d4a
* ETHERSCAN_URL=https://rinkeby.infura.io/v3/yourkeyhere
* ETHERSCAN_API: your api key here
* PROPS_TOKEN_DEPLOYED_BLOCK=3950142
* VALIDATOR_URL=tcp://validator:4004
* ENVIRONMENT=staging
* NODE_ENV=staging

#### 3. Running your instance

Once you have the environment variables set you can run your sidechain node

```
$ cd docker
$ docker-compose up --force-recreate -d
```

#### 4. Finishing up and checking your instance

Take the IP address of your node and go to 

```
http://<ipaddress>:8008/peers
or
http://<ipaddress>:8008/blocks
```


### Conclusion

You should now have a running sidechain node that connects to our staging environment.

The staging environment is in constant flux, and we might restart it once in a while for testing. Contact us and talk to us on slack!
