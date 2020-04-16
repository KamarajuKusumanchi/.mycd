Store bash history per directory.

This was derived from `https://gist.github.com/leipzig/1651133`

Installation

```bash
cd ~
git clone https://github.com/KamarajuKusumanchi/.mycd.git

cat << 'EOF' >> ~/.bash_profile

#------------------------------------------------------------------------------
# Store bash history per directory.
# Overrides 'cd' by 'mycd'. This might lead to some funky behavior.
# See: https://github.com/KamarajuKusumanchi/.mycd
test -f ~/.mycd/mycd.sh && . ~/.mycd/mycd.sh
#------------------------------------------------------------------------------
EOF

source ~/.bash_profile

# ignore the history files in git
echo '.dir_bash_history' >> ~/.config/git/ignore
```
