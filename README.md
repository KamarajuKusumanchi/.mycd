Per directory bash history.

This was derived from https://gist.github.com/leipzig/1651133

Installation

```bash
cd ~
git clone https://github.com/KamarajuKusumanchi/.mycd.git
echo '. $HOME/.mycd/mycd.sh' >> ~/.bash_profile
source ~/.bash_profile

# ignore the history files in git
echo '.dir_bash_history' >> ~/.config/git/ignore
```
