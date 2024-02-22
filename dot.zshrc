# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zsh/.zshrc.                                                                                   
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZDOTDIR="${HOME}/.zsh"

export LANG=en_US.UTF-8
export LC_COLLATE=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8

export VISUAL=vim
export EDITOR=vim
export GIT_EDITOR=vim

# 履歴
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000
function history-all { history -E 1 }

# 読み込み
# 特にMacでbrewのパスをここで通す場合は先にする必要がある
if [ -f ${ZDOTDIR}/add.zshrc ]; then
  source ${ZDOTDIR}/add.zshrc
fi

# 補完を有効化
autoload -Uz compinit && compinit

# 大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
# 矢印で候補を選べるようにする
zstyle ':completion:*:default' menu select=1

# ls
# Macの場合はGNUのlsを使う
# DarwinはMacを指す
if [ "$(uname)" = "Darwin" ] && [[ ! "$PATH" == *"opt/coreutils/libexec/gnubin"* ]]; then
  echo "Plese add gnubin to PATH"
  alias ls="ls -FG"
else
  if [[ "$(type dircolors)" == *"not found"* ]]; then
    echo "dircolors not found"
  else
    eval `dircolors ${ZDOTDIR}/dircolors -b`
    if [ -z "$LS_COLORS" ]; then
      echo "LS_COLORS is empty. Read ~/.dircolors ." 
      if [ ! -e ${HOME}/.dircolors ]; then
        echo "Create ~/.dircolors ."
        dircolors -p > ${HOME}/.dircolors
      fi
      eval `dircolors ${HOME}/.dircolors -b`
    fi
    if [ -n "$LS_COLORS" ]; then
      # 補完候補も着色
      zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    else
      echo "Failed to export LS_COLORS" 
    fi
  fi
  alias ls="ls -F --color=auto"
fi
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"

# cd無しで移動
setopt AUTO_CD

# cd時にls
function chpwd() { ls }

# Python
export PYTHONDONTWRITEBYTECODE=1

# コマンドラインでも#でコメントアウト
setopt interactive_comments

# zinit
source ${ZDOTDIR}/zinitrc

# bindkey
# zinitrcの後じゃないとfast-syntax-highlightingに関連してエラーが発生する
source ${ZDOTDIR}/bindkeyrc

# To customize prompt, run `p10k configure` or edit ~/.zsh/.p10k.zsh.
[[ ! -f ~/.zsh/.p10k.zsh ]] || source ~/.zsh/.p10k.zsh
