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

1. Reboot your system from the flashdrive

1. Connect networking

   ```
   iwctl
   [iwd]# station wlan0 connect <ssid>
   ```

1. Download the setup script

   ```
   curl -L -O https://raw.githubusercontent.com/pbrisbin/arch-setup/main/install
   chmod +x ./install
   ```

1. Configure variables (optional, defaults shown):

   ```bash
   export INSTALL_USER=patrick
   export INSTALL_HOSTNAME=arch-setup
   export INSTALL_DISK=/dev/sda         # no partition number
   export INSTALL_PARTITION_PREFIX=     # e.g. "p"
   export INSTALL_SWAP_SIZE=1G          # valid argument to fallocate
   export INSTALL_NVIDIA=0              # 0|1
   ```

1. Finally, `./install`

## What to Expect

First, the disk will be partitioned and set up for encryption. You'll need to
confirm rewriting the encrypted `/`, supply a passphrase, and give that
passphrase right back again when the drive gets re-opened.

Next, the basic system is installed with one non-`root` user and some creature
comforts, such as ZSH and neovim. You'll need to give a password for the `root`
and non-`root` user.

Then the system will reboot. If you're not me, you would probably stop here.

When you log back in, the install script will re-launch automatically and
configure the rest of the environment with things like:

- Various packages I like or need, ACPID and laptop-mode, Docker, etc
- An SSH key, my dotfiles and `pass(1)` store
- Finally, X and XMonad

I will need to finish configuring GPG manually. For my own reference, here are
some notes...

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

[downloads]: https://www.archlinux.org/download/
