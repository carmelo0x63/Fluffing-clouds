// Configure the provider: GCP
provider "google" {
  credentials = file("cloudchallenge-349217-6d1aa59cbb5b_override.tfvars.json")
  project     = var.gcp_project
  region      = var.gcp_region
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 6
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
  name         = "gcp-web-${random_id.instance_id.hex}"
  machine_type = "e2-micro"
  zone         = var.gcp_region

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  // Make sure flask is installed on all new instances for later steps
  # metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"
  metadata_startup_script = "sudo apt install -yq python3-flask"

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  metadata = {
    ssh-keys = "${var.gcp_username}{:${file("~/.ssh/gcp-static-webserver.pub")}"
  }

  #  // Copies the file as the admin user using SSH
  #  provisioner "file" {
  #    source      = "scripts/app.py"
  #    destination = "/home/${var.gcp_username}/app.py"
  #
  #    connection {
  #      type = "ssh"
  #      #      host        = google_compute_address.static.address
  #      host        = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
  #      user        = var.gcp_username
  #      private_key = file(var.gcp_private_key)
  #    }
  #  }

  #  provisioner "remote-exec" {
  #    inline = [
  #      "export FLASK_ENV=production && nohup flask run --host 0.0.0.0 &",
  #    ]
  #  }

}

#resource "google_compute_firewall" "default" {
#  name    = "flask-app-firewall"
#  network = "default"
#
#  allow {
#    protocol = "tcp"
#    ports    = ["5000", "8000", "80"]
#  }
#}
