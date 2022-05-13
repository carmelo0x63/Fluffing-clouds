resource "null_resource" "node1" {
  provisioner "local-exec" {
    command = "echo 'GoodBye World!' >> ${path.module}/node1.txt"
  }

  provisioner "local-exec" {
    command = "rm ${path.module}/node1.txt"
    when = destroy
  }
}
