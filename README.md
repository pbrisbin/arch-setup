# Arch Setup Script

This script was drafted the last time I installed Arch on a new laptop. It was
then polished up and debugged in VirtualBox. It aims to bring me from a new
machine to my complete, usual environment with as little interaction as
possible.

## Usage

1. Create an installation flashdrive from [Downloads][]:

   Assuming the drive is at `/dev/sdb`:

   ```
   sudo dd bs=4M if=archlinux-...-dual.iso of=/dev/sdb status=progress
   sync
   ```

   [downloads]: https://www.archlinux.org/download/

1. Reboot your system from the flashdrive

1. Connect networking

   ```
   iwctl
   [iwd]# station wlan0 connect <ssid>
   ```

1. Run the setup script

   ```
   curl -L https://raw.githubusercontent.com/pbrisbin/arch-setup/main/install | sh
   ```

## What to Expect

First, `archinstall` will be launched. You need to:

1. Adjust Hostname, if desired
1. Set disk configuration and encryption
1. Set root password
1. Add user named `patrick` with `sudo`
1. Install

After `archinstall` is finished, we add a bunch of configuration files, set up
networking, and drop some more scripts into the user's home directory to be run
on reboot and finish configuring the system.

On reboot, the user's `.zshrc` will print a message to run these scripts, which
install AUR packages and my dotfiles, then `startx`.

Once comfortably in X, there are a few more manual steps, as documented below
for my own reference.

## SSH

TODO

## `pass(1)`

TODO

## GPG

Create a local encryption key, just for `pass(1)`

```sh
gpg --full-generate-key
gpg --export --armor ... > here.key
```

Using my physical master GPG set, re-encrypt my passwords to include it and
generate a new signing subkey. This should be in its own terminal.

```sh
sudo cryptsetup open /dev/sdb1 --type=tcrypt flashdrive
sudo mkdir -p /mnt/flashdrive
sudo mount /dev/mapper/flashdrive /mnt/flashdrive
export GNUPGHOME=/mnt/flashdrive/gnupg

gpg --import here.key
gpg --edit-key {THAT}
> trust

vim ~/.password-store/.gpg-id
...

pass init $(< ~/.password-store/.gpg-id)
pass git push

gpg --edit-key pbrisbin@gmail.com
> addkey

gpg --list-keys --keyid-format SHORT pbrisbin@gmail.com
gpg --output secret-subkeys --export-secret-subkey {SUBKEY}!

gpg send-keys
gpg --export --armor pbrisbin@gmail.com > public.key

sudo umount /mnt/flashdrive
sudo cryptsetup close flashdrive
```

Import the new signing key

```sh
gpg --import < secrete-subkeys
gpg -K
```

At this point, you should be able to:

- Make Git commits
- Read passwords

Delete and re-add the public key in GitHub, and re-push it to S3 once you have
AWS access back.
