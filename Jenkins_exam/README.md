Terraform Structure

    Providers: Specifies AWS as the required provider with version ~> 4.0.

    Resources:

        . VPC: Creates a Virtual Private Cloud (VPC) with DNS support and hostnames enabled.

        . Subnet: Configures a public subnet within the VPC.

        . Internet Gateway: Establishes an Internet Gateway for public internet access.

        . Route Table and Association: Routes public traffic to the Internet Gateway and associates it with the public subnet.

        . Security Groups: Defines inbound and outbound rules for SSH and Jenkins-specific ports.

        . EC2 Instances:

            . Jenkins Master: Primary Jenkins server.
            . Jenkins Worker: Secondary Jenkins server for distributed builds.

        . Key Pair: Creates an SSH key pair for secure access to the EC2 instances.

        . Data Sources: Fetches the latest Amazon Linux 2 AMI.

        . Variables: Manages configuration inputs such as region, VPC CIDR block, subnet CIDR block, instance type, and SSH key name.

        . Outputs: Provides essential information such as VPC ID, Subnet ID, public IPs of Jenkins instances, and Security Group ID.

How to Use

    Prerequisites

        . Install Terraform: Download Terraform

        . Configure AWS CLI with valid credentials.

        . Ensure you have permissions to provision AWS resources.

        . Update the variable my_ip with your real public IP in CIDR format.
    
    Use Terraform CLI

        . terraform init => Initializes Terraform with the required providers.

        . terraform validate => Validates the configuration for errors.

        . terraform plan => Displays the infrastructure plan without making any changes.

        . terraform apply => Applies the configuration and provisions the infrastructure.

        . terraform destroy => Destroys the infrastructure.

Access Jenkins

    Note the public IPs of the Jenkins Master and Worker from the Terraform output:

        . Jenkins Master: jenkins_master_public_ip

        . Jenkins Worker: jenkins_worker_public_ip

    SSH into the instances using the private key: ssh -i <key_name>.pem ec2-user@<public_ip>

    Access the Jenkins interface: Open a browser and navigate to http://<jenkins_master_public_ip>:8080.

    Follow the Jenkins setup wizard instructions.

Outputs

    After applying the configuration, Terraform provides the following outputs:

    VPC ID: ID of the created VPC.

    Subnet ID: ID of the created subnet.

    Jenkins Master Public IP: Public IP address of the Jenkins Master instance.

    Jenkins Worker Public IP: Public IP address of the Jenkins Worker instance.

    Security Group ID: ID of the created Security Group.