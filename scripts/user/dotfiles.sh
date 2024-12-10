echo "For $USER@$(hostname) SSH key:"
ssh-keygen -t rsa -b 4096
curl -F 'sprunge=<-' http://sprunge.us <~/.ssh/id_rsa.pub
echo "Install this key in GitHub/GitLab (or don't). Then enter to continue."
read -r

if ! git clone git@github.com:pbrisbin/dotfiles ~/.dotfiles; then
  # Assume that failed because we didn't install the SSH keys. We can still
  # finish the set up using an HTTP clone of my dotfiles
  git clone https://github.com/pbrisbin/dotfiles ~/.dotfiles
fi

# Avoid prompting, respect uninstalled rcrc
RCRC=$HOME/.dotfiles/config/rcm/rcrc rcup -f

# Stack
stack setup
stack install xmonad xmonad-contrib

sudo tee /etc/pacman.d/hooks/stack-completions.hook <<'EOM'
[Trigger]
Operation = Upgrade
Type = Package
Target = stack-static

[Action]
Description = Updating stack completions
When = PostTransaction
Depends = stack-static
Exec = /bin/sh -c 'stack --zsh-completion-script $(which stack) > /usr/share/zsh/site-functions/_stack'
EOM
