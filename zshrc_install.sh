#!/bin/bash
#

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#默认安装在 ~/.oh-my-zsh/custom/plugins/

#mkdir zsh_extensions
#cd zsh_extensions

#

# git clone git://github.com/joelthelion/autojump.git
# cd autojump
# ./install.py

#错误会显示其他的颜色
#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
#echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
#source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

#命令提示
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

#git-open
git clone https://github.com/paulirish/git-open.git $ZSH_CUSTOM/plugins/git-open



