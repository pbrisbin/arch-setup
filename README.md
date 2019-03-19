# Arch Installation Script

**NOTE**: This is super specific to me, but could be used as a reference for
someone else.

**OTHER NOTE**: I wrote this as I manually configured my most recent laptop so
it has yet to be tested end-to-end. That said, it's meant to be used only on a
fresh system so the worst it can do is fail and you're just back where you were
to begin with.

## Context

Everything comes from [Installation Guide][guide], or other dedicated sections
in the Arch wiki.

## Usage

1. Create an installation flashdrive from [Downloads][]


   Assuming the drive is at `/dev/sdb`:

   ```
   sudo dd bs=4M if=archlinux-2016.12.01-dual.iso of=/dev/sdb status=progress
   sync
   ```

1. Reboot your system from the flashdrive

1. Download the setup script

   ```
   curl -L -O https://raw.github.com/pbrisbin/arch-setup/install
   chmod +x ./install
   ```

1. Configure required variables:

   ```bash
   export INSTALL_DISK=
   export INSTALL_HOSTNAME=
   export INSTALL_EN=
   export INSTALL_WLAN=
   export INSTALL_USER=
   export INSTALL_SWAP_SIZE=
   ```

1. Be prepared to log passwords

   This script prompts for 3 passwords:

   - Encrypted `/` key
   - `root` user password
   - non-`root` user password

   Be prepared to write these somewhere as you enter them. My own trick is to
   use https://passphrase-me.herokuapp.com on a nearby machine and leave the
   tabs open until I'm in my full system and can put them into `pass(1)`.

1. `./install disks`

   This will set up an encrypted root and prepare the new filesystem. It will
   bring you to the point where you need to `arch-chroot` and proceed from
   there.

1. `./install system`

   This will minimally configure a non-graphical system with networking and a
   non-`root` user. This will bring you to the point where it's time to reboot
   into the real system.

   If you're not me, it's likely you want to stop here.

1. `./install user`

   Finishes full configuration of the Graphical system (XMonad) using my
   personal dotfiles. Also sets up acpid, docker, and other packages I need. It
   does set up `pass(1)`, but that won't work until I finish configuring GPG,
   which is a manual thing for now.

1. Manually configure GPG

   For my own reference:

   - Mount encrypted flashdrive or master keys with truecrypt
   - Add a new signing key for this machine:

     ```
     gpg --homedir /mnt/truecrypt1/gnupg --edit-key {EMAIL}
     # addkey, RSA Sign, 4096
     ```

     ```
     gpg --homedir /mnt/truecrypt1/gnupg --send-keys {MASTER}
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

[guide]: https://wiki.archlinux.org/index.php/installation_guide
[downloads]: https://www.archlinux.org/download/
