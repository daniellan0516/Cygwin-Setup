source /usr/share/bash-completion/bash_completion

# Path to your oh-my-zsh installation.
export STARSHIP_CONFIG=C:\\cygwin\\root\\home\\azure\\.config\\starship.toml
export PATH=/opt/fd/8.4.0:$PATH
#export PATH=/opt/vscode/1.69.1:$PATH
export PATH=/opt/fzf/0.30.0:$PATH
export PATH=/opt/sudo/0.2020.01.26:$PATH
export PATH=/opt/PowerShell-7.2.5-win-x64:$PATH
export PATH=/opt/node-v16.15.1-win-x64:$PATH
export PATH=/opt/eclipse-2022-06/:$PATH
export LANG=en_US.UTF-8
export EDITOR='nvim'
export PROFILE=.pwsh.ps1
export FZF_DEFAULT_OPTS='--layout=reverse --border'
export FZF_COMPLETION_TRIGGER='~~'

# startship
eval "$(starship init bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
set -o vi

# 自動環境變數
export dotenv=.env
export orienv=/tmp/.orienv
[ -f $orienv ] && /usr/bin/rm $orienv

# aliases
alias nvim="nvim -u c:/cygwin/root/home/azure/.nvimrc"
alias vi=vim
alias rm=recycle
alias del=recyle
alias ssh=/cygdrive/c/cygwin/root/bin/ssh
alias ls='ls --color'
alias ll='ls -al'
alias ltr='ls -ltr'
alias l=ls
alias mans=tldr
alias reboot='shudown -r'
alias poweroff='shutdown -s'

cd() {
  if (( $# == 0 )); then
    builtin cd
    return
  fi

  if [ -f "$orienv" ] && [[ "$env_root" =~ $(realpath $@) ]] && [[ "$env_root" != $(realpath $@) ]]; then
    echo -e "\\033[31m還原環境變數\\033[0m"
    grep -E 'export' $dotenv | awk -F" " '{print $2}' | awk -F= '{print $1}' | while read line; do unset $line; done
    source $orienv
    /usr/bin/rm $orienv
    unset env_root
  fi

  if [ -f "$orienv" ] && [[ ! "$(realpath $@)" =~ "$env_root" ]] && [[ ! "$(realpath $@)" != "$env_root" ]]; then
    echo -e "\\033[31m還原環境變數\\033[0m"
    source $orienv
    /usr/bin/rm $orienv
    unset env_root
  fi

  builtin cd "$@"

  if [ -f "$dotenv" ]; then
    if [[ "$(realpath $PWD)" == "$env_root" ]]; then
      return
    fi
    echo -e "\\033[31m載入環境變數\\033[0m"
    env > .tmpfile
    cat .tmpfile | sed -e 's/C:\\/\/cygdrive\/c\//g' | \
                   sed -e 's/\\/\//g' | \
                   sed -e 's/\ /\\\ /g' | \
                   sed -e 's/\;/\:/g' | \
                   sed '/\(x86\).*\=/d' | \
                   sed '/^PROFILEREAD/d' > $orienv
    /usr/bin/rm .tmpfile
    export env_root=$(realpath "$PWD")
    source $dotenv
    source ~/.bashrc
  fi

}

vim() {
  [ "$@" ] && nvim $@ && return

  nvim $(fzf --preview 'cat {}')
}

gfa() {
  files="$(/usr/libexec/git-core/git diff --name-only 2>/dev/null)" 

  [ "$(git status 2>/dev/null)" = "" ] &&
  echo "非git資料夾" && return
  
  [ $files = "" ] && 
  echo "沒有異動的檔案" && return

  git status -s | awk '{print $NF}' | fzf -m --ansi --reverse --preview '/usr/libexec/git-core/git diff --color=always {} || cat {}' > .tmpfile
  
  sed -i ':a;N;$!ba;s/\n/ /g' .tmpfile
  git add $(cat .tmpfile)
  rm -rf .tmpfile
}


code() {
  if [ "$@" ]; then
    nohup /opt/vscode/1.69.1/code $@ 1>/dev/null 2>/dev/null & 
    return
  else
    nohup /opt/vscode/1.69.1/code ./ 1>/dev/null 2>/dev/null & 
    return
  fi
}
