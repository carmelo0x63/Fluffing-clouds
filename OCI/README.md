# Virtual Lab on Oracle Cloud Infrastructure (OCI)
**Credits**: adapted from [gszathmari/homelab-on-oracle-cloud](https://github.com/gszathmari/homelab-on-oracle-cloud). Give them a star if you please.

This Terraform plan builds a virtual lab environment on the Oracle Cloud Infrastructure (OCI) within the [always free](https://www.oracle.com/cloud/free/) limits, some details:
 - Two Oracle Autonomous Databases with powerful tools like Oracle APEX and Oracle SQL Developer
 - Two AMD Compute VMs
 - Up to 4 instances of ARM Ampere A1 Compute with 3,000 OCPU hours and 18,000 GB hours per month
 - Block, Object, and Archive Storage; Load Balancer and data egress; Monitoring and Notifications

## About the project

The following resources are deployed within the free-tier offer:

- 1x **VM.Standard.E2.1.Micro** instances (1 OCPU, 1 GB RAM, x86_64)
- 1x **VM.Standard.A1.Flex** instance (4 OCPU, 24 GB RAM, aarch64)
<!--
- An additional **59 GB volume** attached to the _VM.Standard.A1.Flex_ instance
- A **volume backup policy** taking one automatic snapshot per week (retained for 5 weeks)
-->
- Reasonably sane configuration settings

## Requirements

- Terraform v1.1.9 (or higher) installed on your computer
- An Oracle Cloud Infrastructure (OCI) account
- An [SSH public-private key pair](https://docs.oracle.com/en/cloud/cloud-at-customer/occ-get-started/generate-ssh-key-pair.html)
- Basic knowledge of the Linux command line

## Configuration

1. In order to deploy your lab environment with Terraform, clone or download this repository to your computer

2. OCI documentations has a section describing how to [configure the provider](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#configuring_the_terraform_provider).</br> 
   Below are listed the most important settings to be stored into [terraform.tfvars](./terraform.tfvars.ori) configuration file:
   - `tenancy_oid`
   - `user_ocid`
   - `private_key_path`
   - `fingerprint`
   - `region`
   **NOTE**: please be careful with the value `private_key_path`, as this is not your SSH private key but the [API signing key](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#two). Download it and store it to a safe place upon creation!!!</br>
   A pre-configured file, formatted for OCI CLI/SDK, can be downloaded from `Identity > Users > User Details > API Keys`!

3. Depending on your chosen `region`, retrieve the image ID from [this page](https://docs.oracle.com/en-us/iaas/images/) for your instances.

   - Choose any of your preferred images (e.g. Ubuntu, CentOS) for the **VM.Standard.E2.1.Micro** instances
   - Choose the `aarch64` variation of Ubuntu 20.04, Oracle Linux 7.x or Oracle Linux 8.x Linux distributions for the **VM.Standard.A1.Flex** instance

4. Replace `vm_image_ocid_x86_64` in [terraform.tfvars](./terraform.tfvars.ori) with your chosen image ID for the **VM.Standard.E2.1.Micro** instance

5. Replace `vm_image_ocid_ampere` in [terraform.tfvars](./terraform.tfvars.ori) with your chosen image ID for the **VM.Standard.A1.Flex** instance

6. Add your SSH public key to the `ssh_public_key` configuration parameter in [terraform.tfvars](./terraform.tfvars.ori)

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

Congratulations! Your VMs are ready to use. The login details are available [here](https://docs.oracle.com/en-us/iaas/Content/Compute/References/images.htm#Oracle__linux-users).

## Where to go from here

- Navigate to the [Instances page on the OCI dashboard](https://cloud.oracle.com/compute/instances) to obtain the sign-in details of your new virtual instances. tl;dr:
```
$ ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/oci-static-server ubuntu@<ip_address>
```

<!--
- Partition, format and mount the additional 59 GB large `/dev/sdb` volume on your **VM.Standard.A1.Flex** instance.
-->
- Install all security updates on your new instances.

- Only port `tcp/22` is open to the internet by default. If you need to allow further ports, modify the [network-subnet-public.tf](network-subnet-public.tf) file to your liking. If you have `iptables` or similar running on your instance, you may need to change your firewall settings on the instance, too.

- Explore the other OCI [free tier](https://www.oracle.com/cloud/free/) services as well.

- Refer to the project ideas if you have some free capacity on your instances.

**NOTE**: Oracle is providing a generous amount of free egress traffic ([10 TB/month](https://www.oracle.com/cloud/networking/networking-pricing.html))

