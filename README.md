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

1. Download the setup script

   ```
   curl -L -O https://raw.githubusercontent.com/pbrisbin/arch-setup/master/install
   chmod +x ./install
   ```

1. Configure variables (optional, defaults shown):

   ```bash
   export INSTALL_USER=patrick
   export INSTALL_HOSTNAME=arch-setup
   export INSTALL_DISK=/dev/sda         # no partition number
   export INSTALL_SWAP_SIZE=1G          # valid argument to fallocate
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

It will then instruct me to finishing configuring GPG manually. For my own
reference, because I always forget, that means the following:

- Mount my encrypted flashdrive of master keys with truecrypt
- Add a new signing key for this machine:

  ```
  gpg --homedir /mnt/truecrypt1/gnupg --edit-key {EMAIL}
  # addkey, RSA Sign, 4096
  ```

  ```
  gpg --homedir /mnt/truecrypt1/gnupg --send-keys {MASTER}

  # Updates files.pbrisbin.com
  push-public-key
  ```

- Export the secret keys for just your (shared) encryption key and the (new)
  signing key you just created:

  ```
  gpg --homedir /mnt/truecrypt1/gnupg \
    --output secret-subkeys \
    --export-secret-subkeys {SHARED ENCRYPTION}! {NEW SIGNING}!
  ```

- Import those and verify:

  ```
  gpg --import secret-subkeys
  gpg -K
  ```

  You should see `#`s next to all keys except those you expect to have secret
  keys for on this machine.

NOTE: you will have to kill gpg-agent to unmount the flashdrive.

[downloads]: https://www.archlinux.org/download/
