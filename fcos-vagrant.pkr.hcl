source "virtualbox-iso" "fcos-vagrant" {
  cpus = 4
  memory = 8192
  disk_size = 8192
  guest_os_type = "Linux_64"
  hard_drive_interface = "sata"
  virtualbox_version_file = ""
  guest_additions_mode = "disable"
  export_opts = [
    "--manifest",
    "--vsys", "0",
    "--description", "fedora-coreos-stable",
    "--version", "33.20210301.3.1",
  ]
  vboxmanage = [
    ["modifyvm", "{{ .Name }}", "--graphicscontroller", "vmsvga"],
    ["modifyvm", "{{ .Name }}", "--vram", "9"],
  ]
  iso_url = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/33.20210301.3.1/x86_64/fedora-coreos-33.20210301.3.1-live.x86_64.iso"
  iso_checksum = "sha256:d19a3c799f18871b996c512a87daa47de6519b6f0dcf1cca61e83c3a0a8bff1e"
  output_directory = "${path.root}/build"
  http_directory = "${path.root}/http"
  ssh_port = 22
  ssh_username = "vagrant"
  ssh_private_key_file = "${path.root}/files/vagrant-id_rsa"
  ssh_timeout = "20m"
  ssh_handshake_attempts = 100
  boot_wait = "25s"
  boot_command = [
    "curl -LO http://{{ .HTTPIP }}:{{ .HTTPPort }}/config.ign<enter><wait>",
    "sudo coreos-installer install /dev/sda --ignition-file config.ign && sudo reboot<enter>",
    "<wait3m>",
  ]
  shutdown_command = "sudo shutdown -h now"
}

build {
  sources = ["source.virtualbox-iso.fcos-vagrant"]

  post-processor "artifice" {
    files = ["${path.cwd}/build/info.json"]
  }
  post-processor "vagrant" {
    output = "${path.root}/build/vagrant.box"
    compression_level = 9
    provider_override = "virtualbox"
  }
}
