# Install and Configure Terraform on AWS CloudShell

1. Confirm CloudShell environment and AWS Creds
    ```
    $ uname -a
    $ aws --version
    $ aws sts get-caller-identity
    $ aws configure list
    ```
2. Install terraform (CLI method)
    ```
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum -y install terraform
    terraform -v
    ```
