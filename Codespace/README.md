# Instructions for running the lab in Codespace VM

Codespace VM will be created with Containerlab already installed and this git repo will be already cloned to the VM.

To get the sonic docker image:

```bash
docker pull ghcr.io/sajusal/sonic-saju:202511
```

Verify using `docker images` command.

Open the sonic-evpn.clab.yml and replace the sonic image path with the image page you see in the above output.

```diff
- image: vrnetlab/sonic_sonic-vs:2511
+ image: ghcr.io/sajusal/sonic-saju:202511
```

Install the sshpass package.

```bash
sudo apt-get update && sudo apt-get install -y sshpass
```

Deploy the lab:

```bash
clab dep
```

Follow the rest of the instructions in the main page.
