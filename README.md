# Rocket Pool Node Provisioning

## Configure Ansible Control Node
I used Ubuntu in WSL2 on my Windows 10 laptop as my control node.
### Configure SSH
1. 	Add following to /etc/hosts:
```
10.0.0.72 nuc1
```
2. Copy existing key pair or generate new pair using:
```
ssh-keygen -t ed25519 -C "your_email@example.com"
```
3. Add following to .bashrc:
```
alias loadkey='eval "$(ssh-agent -s)"; ssh-add ~/.ssh/id_ed25519'
```
4. Add following to ~/.ssh/config:
```
Host nuc1
  HostName 10.0.0.72
```
### Install Ansible and dependencies
I used `pip` instead of `apt` to access newer Ansible version.
```
sudo apt install python3-pip
pip3 install --user ansible
```
Close/reopen unbuntu terminal.
```
ansible-galaxy collection install community.general
ansible-galaxy install dev-sec.os-hardening dev-sec.ssh-hardening jnv.unattended-upgrades geerlingguy.docker
```

## Install Ubuntu Server 20.04 LTS on Rocket Pool node
I used Ubuntu in WSL2 on my Windows 10 laptop to generate an Ubuntu auto intall iso image following [this](https://gist.github.com/s3rj1k/55b10cd20f31542046018fcce32f103e) Howto. 
1. Download ISO Installer:
```
wget https://ubuntu.volia.net/ubuntu-releases/20.04.2/ubuntu-20.04.2-live-server-amd64.iso
```

2. Create ISO distribution directory:
```
mkdir -p iso/nocloud/
```

3. Extract ISO using 7z:
```
7z x ubuntu-20.04.2-live-server-amd64.iso -x'![BOOT]' -oiso
```

4. Create empty meta-data file:
```
touch iso/nocloud/meta-data
```

5. Copy [user-data](iso/nocloud/user-data) file to `iso/nocloud/user-data`. *Review/update user-data file before proceeding.  Encrypted password and SSH public key are missing and must be provided.*

6. Update boot flags with cloud-init autoinstall:
```
sed -i 's|---|autoinstall ds=nocloud\\\;s=/cdrom/nocloud/ ---|g' iso/boot/grub/grub.cfg
sed -i 's|---|autoinstall ds=nocloud;s=/cdrom/nocloud/ ---|g' iso/isolinux/txt.cfg
```

7. Disable mandatory md5 checksum on boot:
```
md5sum iso/.disk/info > iso/md5sum.txt
sed -i 's|iso/|./|g' iso/md5sum.txt
```
8. Create Install ISO from extracted dir:
```
xorriso -as mkisofs -r \
  -V Ubuntu\ custom\ amd64 \
  -o ubuntu-20.04.2-live-server-amd64-autoinstall.iso \
  -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot \
  -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot \
  -isohybrid-gpt-basdat -isohybrid-apm-hfsplus \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin  \
  iso/boot iso
```
9. Burn iso image to USB flash drive using Rufus on Windows.
![Rufus](Rufus.png)
10. Boot Rocket Pool node from USB flash drive image to complete the unattended install.

## Verify SSH access to Rocket Pool node
Login to Rocket Pool node as initial user.
```
ssh dan@nuc1
```
*If receive `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!`, delete offending key from `~/.ssh/known_hosts` on local host.*

## Prepare Rocket Pool node O/S and create Rocket Pool user
```
cd ~/git/rocketpool-node-provision
ansible-playbook base.yaml --ask-become-pass
```

## Install and configure Rocket Pool Smart Node Stack
```
ansible-playbook <instance>.yaml install-rocketpool.yaml
```
Where instance is `dev` or `prod`.