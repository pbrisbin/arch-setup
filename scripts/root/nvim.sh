ln -s /usr/bin/nvim /usr/bin/vim

mkdir -p /root/.config/nvim

cat >/root/.config/nvim/init.vim <<'EOM'
set background=light
set expandtab
set shiftwidth=2
set smartindent
set textwidth=80
EOM
