This section shows how to separate statements from data.</br>
Rather than putting all of our code into one single file we now have:
- variables.tf     : any variables are declared here
- terraform.tfvars : values are instantiated here
- main.tf          : the actual code

```
$ terraform init
...


$ terraform apply
...
Changes to Outputs:
  + text = "Hello, variable world!"
...


$ terraform show
Outputs:
text = "Hello, variable world!"


$ terraform destroy
...
```

