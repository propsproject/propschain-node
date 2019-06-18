# sidechain-node

![Props Token](https://propsproject.com/static/images/main-logo.png)

Everything that is needed to set up a sidechain node that connects to props

WIP

## Setup

We're using AWS as our cloud provider, thus we provide you with a terraform setup that allows you to quickly create a launch configuration that creates an instance.

You're not obligated to use these terraform files, you can use them as a guide to create your own instance on AWS or another cloud provider.

### Folder structure

* ***/docker***: this contains the docker-compose.yaml file that creates the sidechain node. This is all you need if you don't want to use our terraform files
* ***/terraform/environments***: contains folders for each environment (staging, production, etc) with the terraform configuration for each environment 
* ***/terraform/modules***: custom terraform modules 

### Terraform

This step is optional if you want to launch your own instance

Download terraform: https://www.terraform.io/downloads.html

