# aws

Terraform and Awspec.

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
