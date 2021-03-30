# FCOS Vagrant

> Build Fedora CoreOS(FCOS) box for Vagrant

## Usage

1. Generate ignition file
   ```
   # If you use podman, please replace docker to podman
   $ docker run -i --rm quay.io/coreos/fcct:release --pretty --strict < files/config.yml > http/config.ign
   ```
1. Run packer
   ```
   $ packer build fcos-vagrant.pkr.hcl
   ```
