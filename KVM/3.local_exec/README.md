```
$ cat > test.tf << EOF
resource "null_resource" "node1" {
  provisioner "local-exec" {
    command = "echo 'GoodBye World!' >> \${path.module}/node1.txt"
  }

  provisioner "local-exec" {
    command = "rm \${path.module}/node1.txt"
    when = destroy
  }
}
EOF
```


```
$ terraform init
Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/null...
- Installing hashicorp/null v3.1.0...
- Installed hashicorp/null v3.1.0 (signed by HashiCorp)
...


$ terraform apply
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # null_resource.node1 will be created
  + resource "null_resource" "node1" {
      + id = (known after apply)
    }
...
null_resource.node1: Creating...
null_resource.node1: Provisioning with 'local-exec'...
null_resource.node1 (local-exec): Executing: ["/bin/sh" "-c" "echo 'GoodBye World!' >> ./node1.txt"]
null_resource.node1: Creation complete after 0s [id=2005057281456318866]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

At this point, file `node1.txt` has been automatically generated.</br>

$ ls -l node1.txt
...
-rw-rw-r--. 1 mellowiz mellowiz   15 Jan 15 11:27 node1.txt
...

$ cat node1.txt
GoodBye World!

$ terraform show
# null_resource.node1:
resource "null_resource" "node1" {
    id = "2005057281456318866"
}

$ terraform state list
null_resource.node1

$ terraform destroy
null_resource.node1: Refreshing state... [id=2005057281456318866]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # null_resource.node1 will be destroyed
  - resource "null_resource" "node1" {
      - id = "2005057281456318866" -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

null_resource.node1: Destroying... [id=2005057281456318866]
null_resource.node1: Provisioning with 'local-exec'...
null_resource.node1 (local-exec): Executing: ["/bin/sh" "-c" "rm ./node1.txt"]
null_resource.node1: Destruction complete after 0s

Destroy complete! Resources: 1 destroyed.```

