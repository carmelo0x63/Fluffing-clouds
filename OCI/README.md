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
- An [SSH public-private key pair](https://docs.oracle.com/en/cloud/cloud-at-customer/occ-get-started/generate-ssh-key-pair.html) which can be generated locally (e.g. `ssh-keygen`) or through the GUI. Make sure it is stored to a safe place upon creation!!!
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

   **NOTE**: `private_key_path` is **not** your SSH private key but the [API signing key](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#two).</br>
   A pre-configured file, formatted for OCI CLI/SDK, can be downloaded from `Identity > Users > User Details > API Keys`. Converting it to `*.tfvars` format is immediate!

3. Depending on your chosen `region`, retrieve the image ID from [this page](https://docs.oracle.com/en-us/iaas/images/) for your instances.

   - Choose any of your preferred images (e.g. Ubuntu, CentOS) for the **VM.Standard.E2.1.Micro** instances
   - Choose the `aarch64` variation of Ubuntu 20.04, Oracle Linux 7.x or Oracle Linux 8.x Linux distributions for the **VM.Standard.A1.Flex** instance

4. Replace `vm_image_ocid_x86_64` in [terraform.tfvars](./terraform.tfvars.ori) with your chosen image ID for the **VM.Standard.E2.1.Micro** instance. For example:
  - go to: [Canonical-Ubuntu-22.04-Minimal-2023.02.14-0](https://docs.oracle.com/iaas/images/image/de4fc878-cd7a-41ab-914b-4f7684a024c9/)
  - look for: `eu-zurich-1`
  - copy and paste: `ocid1.image.oc1.eu-zurich-1.aaaaaaaak56oiuiucv6mpdwrhppxav34ppd6neqj5jyx3nfqhvhkox22fwca`

5. Replace `vm_image_ocid_ampere` in [terraform.tfvars](./terraform.tfvars.ori) with your chosen image ID for the **VM.Standard.A1.Flex** instance. For example:
   - go to: [Canonical-Ubuntu-22.04-Minimal-aarch64-2023.02.14-0](https://docs.oracle.com/en-us/iaas/images/image/00a089e7-2867-4037-81fa-a4f775a23333/)
   - look for: `eu-zurich-1`
   - copy and paste: `ocid1.image.oc1.eu-zurich-1.aaaaaaaa62oinkcq5ls2gl3zfsugbkvo66lqxevkrkeybxj24hcrgef36utq`

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

Congratulations! Your VMs are ready to use. The login details are available [here](https://docs.oracle.com/en-us/iaas/Content/Compute/References/images.htm#Oracle__linux-users).</br>

Useful comands:
- `terraform show`
- `terraform destroy`

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

