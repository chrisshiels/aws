# terraform

Terraform modules, stacks and providers with Awspec tests.


## Usage

    host$ # Install Terraform.
    host$ cd bin
    host$ make
    host$ PATH=`pwd`:$PATH
    host$ cd ..

    host$ # Install Awspec.
    host$ bundle install --path vendor/bundle

    host$ # Run Terraform.
    host$ cd providers/aws/eu-west-1/elbasgrds/dev/
    host$ terraform init
    host$ terraform version
    host$ terraform plan
    host$ terraform apply

    host$ # Run Awspec.
    host$ cd test
    host$ bundle exec awspec init
    host$ bundle exec rake spec

    host$ # Run Terraform.
    host$ cd ..
    host$ terraform destroy


## Description

A Terraform code structure which meets the following requirements:


* Support composable code structured around *module*, *stack*, and *provider*
  (environment) layers without repeated code or additional tooling.  ✓


* Support tests using Awspec for both unit tests of individual modules and
  integration tests for providers.  ✓


* Support multiple environment deployments in the same AWS account through
  sensibly named AWS assets  ✓:

    * e.g.  sg-elbasgrds-dev-app-elb\
      *sg* prefix denotes security group.\
      *elbasgrds* denotes name of stack.\
      *dev* denotes name of provider.\
      *app-elb* denotes function of asset.\
      i.e. security group for application's elastic load balancer
           in dev deployment of stack elbasgrds.

    * e.g.  elb-elbasgrds-dev-app\
      *elb* prefix denotes elastic load balancer.\
      *elbasgrds* denotes name of stack.\
      *dev* denotes name of provider.\
      *app* denotes function of asset.\
      i.e. application's elastic load balancer
           in dev deployment of stack elbasgrds.

    * e.g.  db-elbasgrds-dev-app\
      *db* prefix denotes RDS database instance.\
      *elbasgrds* denotes name of stack.\
      *dev* denotes name of provider.\
      *app* denotes function of asset.\
      i.e. application's RDS database instance
           in dev deployment of of stack elbasgrds.


* Support sensibly designed security groups so all non-external network access
  is written in terms of other security groups and not network ranges.  ✓
