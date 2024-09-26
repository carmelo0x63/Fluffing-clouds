# Fluffing clouds :)
A collection of scripts to build infrastructure as code (IaC) both on-premises and in the cloud.</br>
The directories listed below cover several technologies such as [OpenTofu](https://opentofu.org/), [Ansible](https://www.ansible.com/), and [cloud-init](https://cloud-init.io/).</br>

- [cloud-init + QEMU](./cloud-init/README.md)
- [Terraform + KVM](./KVM/README.md)
- [Local Kubernetes/K3s cluster](./K3s/README.md)
- [Oracle Cloud Infrastructure (OCI)](./OCI/README.md)
- [Google Cloud Platform (GCP)](./GCP/README.md)
- [Amazon Web Services (AWS)](./AWS/README.md)

----

### OpenTofu cheatsheet
```
% tofu -version

% tofu init [-upgrade]

% tofu validate

% tofu fmt

% tofu apply -auto-approve

% tofu show

% tofu state list

% tofy output

% tofu destroy -auto-approve
```
