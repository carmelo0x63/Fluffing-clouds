# tl;dr: how to run your first Terraform script
Let's begin to get some behaviour out of our Terraform installation. Those who are eager for quick results ought just to copy and paste.

### Create one single Terraform configuration file
```
$ cat > test.tf << EOF
output "text" {
  value = "hello world"
}
EOF
```

### Initialize the working directory
```
$ terraform init
Initializing the backend...
Initializing provider plugins...
Terraform has been successfully initialized!
...
```

### APPLY!!!
```
$ terraform apply
Changes to Outputs:
  + text = "hello world"
  ...
  Enter a value: yes
...
Outputs:
text = "hello world"
```

### Check the result
```
$ terraform show
Outputs:

text = "hello world"
```

### Clean-up
```
$ terraform destroy
Changes to Outputs:
  - text = "hello world" -> null
...
  Enter a value: yes
...
Destroy complete! Resources: 0 destroyed.
```

