resource "null_resource" "outfile" {
  provisioner "local-exec" {
    command = "echo 'GoodBye World!' >> outfile_${self.id}.txt"
  }

  provisioner "local-exec" {
    command = "rm outfile_${self.id}.txt"
    when    = destroy
  }
}

