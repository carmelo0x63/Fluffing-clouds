# Virtual Lab on Amazon Web Services (AWS)
This Terraform plan builds a virtual lab environment on the Amazon Web Services (AWS) infrastructure composed of:
- One EC2 instance (t3-large, PAID)

## About the project

The following resources are deployed within the free-tier offer:

- 1x **t3-large** instance (2 vCPU, 8 GB RAM, x86_64)
- Reasonably sane configuration settings

## Requirements

- Terraform v1.4 (or higher) installed on your computer
- An Amazon Web Services (AWS) account
- An [Amazon EC2 key pairs and Linux instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) which can be generated locally (e.g. `ssh-keygen`) or through the GUI. Make sure it is stored to a safe place upon creation!!!
- Basic knowledge of the Linux command line

## Configuration

1. TBD
2. TBD

## Deployment

Once your [terraform.tfvars](./terraform.tfvars.ori) is complete, your new lab environment is ready for deployment.

1. Run Terraform init first:

   ```sh
   terraform init
   ```

1. Optionally, build a Terraform plan:

   ```sh
   terraform plan -out=tfplan
   ```

1. Deploy your lab environment:

   ```sh
   terraform apply ["tfplan"]
   ```

Congratulations! Your VMs are ready to use. The login details are available [here](https://docs.oracle.com/en-us/iaas/Content/Compute/References/images.htm#Oracle__linux-users).</br>

Useful comands:
- `terraform show`
- `terraform destroy`

## Where to go from here

- Navigate to the **EC2 page on the AWS console** to obtain the sign-in details of your new virtual instances. tl;dr:
```
$ ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/aws-static-server ubuntu@"$(cat aws_remote_ip.txt)"
```

<!--### Ansible quirks
In case the Ansible playbook has to be re-run, the following one-liner shall be run from the same directory where Terraform state lives:
```
$ ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i remote_ip.txt --private-key ~/.ssh/aws-static-server -u ubuntu ~/ansible/playbook.yaml
```
-->

