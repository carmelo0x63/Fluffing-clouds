```
$ cat > outputs.tf << EOF
output "text" {
  value = file("\${path.module}/text.txt")
}
EOF

$ cat > text.txt << EOF
Hello world from text file!
EOF
```



```
$ terraform init

$ terraform apply
Changes to Outputs:
  + text = <<-EOT
        Hello world from text file!
    EOT
...
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

text = <<EOT
Hello world from text file!

EOT

$ terraform show
Outputs:

text = <<-EOT
    Hello world from text file!
EOT

$ terraform destroy
```

