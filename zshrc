# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#
# eval "$(starship init zsh)"
cd $(cat /tmp/last_dir)
export EDITOR=nvim
# Path to your oh-my-zsh installation.
export ZSH="/home/leo/.oh-my-zsh"
plugins=(git extract vi-mode autopep8 zsh-autosuggestions transfer)
source $ZSH/oh-my-zsh.sh

# History in cache directory:
HISTSIZE=100000
SAVEHIST=100000

# ZSH_THEME='powerlevel10k/powerlevel10k'
# ZSH_THEME="robbyrussell"

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char
bindkey -v '^[[A' history-beginning-search-backward
# bindkey '^I' autosuggest-accept

zle -N zle-keymap-select
# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
	 [[ $1 = 'block' ]]; then
	echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
	   [[ ${KEYMAP} == viins ]] ||
	   [[ ${KEYMAP} = '' ]] ||
	   [[ $1 = 'beam' ]]; then
	echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
	zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
	echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
# below is for autojump
[[ -s /home/leo/.autojump/etc/profile.d/autojump.sh ]] && source /home/leo/.autojump/etc/profile.d/autojump.sh
autoload -U compinit && compinit -u

function c {
    xclip -selection clipboard
}

# function cd {
        # builtin cd "$@" && ls -F
# }

function pcsv {
    perl -pe 's/((?<=,)|(?<=^)),/ ,/g;' "$@" | column -t -s, | less  -F -S -X -K
}

# alias z='zathura --fork'
alias sys='sudo systemctl'
alias p='xclip -selection clipboard -o '
alias y=yay
alias f='fzf.sh'
alias grep='grep -i --color=auto'
alias pgrep='grep -Pi --color=auto'
alias ssr='ssh leo@129.94.138.103'
alias se='cd /mnt/da/Dropbox/scripts'
alias cf='cd `cdfzf.sh`'
alias cdd='cd /mnt/da/Dropbox'
alias cdw='cd ~/Downloads'
alias cdc='cd ~/Documents'
alias cds='cd $(p)'
alias gt='cd /tmp/'
alias cddt='/mnt/da/Dropbox/phd_thesis1'
alias cddr='/mnt/da/Dropbox/Raphale_Leo'
alias cddp='/mnt/da/Dropbox/WingWah-Leo/innovation=invention+commercialization'
alias ts='trans :zh '
export PATH=$PATH:/home/leo/bin
alias v='nvim'
alias sv='sudo nvim'
alias sshwrds='ssh z3486253@wrds-cloud.wharton.upenn.edu'
alias doc2pdf="libreoffice --headless --convert-to pdf $1"
alias mc='xmodmap -e "pointer = 1 2 3"'
alias mcc='xmodmap -e "pointer = 3 2 1"'
alias bm='cat ~/Templates/beamer.tex > '
alias py='/usr/bin/python3.8'
alias ipy='python3.8 -m IPython'
alias pip='python3.8 -m pip'
alias sshk='ssh z3486253@katana.restech.unsw.edu.au'
alias mkd='mkdir -p'
alias jup='sudo /usr/bin/anaconda3/bin/jupyter'
alias h=fh
alias ls=exa
alias du=dust
alias q=bat
alias ps=procs

function lo {
	libreoffice $1 &
}
function sta {
	stata-mp -b -q $1
}

function jl {
	w=$(xdotool getwindowfocus getwindowpid)
	tmux new python3.8 -m jupyterlab --browser=chromium &
	sleep 0.5
	kill $w
}

function openstata {
	w=$(xdotool getwindowfocus getwindowpid)
	xstata-mp $1
	sleep 0.5
	kill $w
}

function ep {
	eval $(xclip -o)
}

#function stt {
#	stata-mp -b -q "$1.do" && less "$1.log"
#	}

function rsyk {
	rsync -avh $1 z3486253@kdm.restech.unsw.edu.au:/srv/scratch/ausequity
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/leo/bin/google-cloud-sdk/path.zsh.inc' ]; then . '/home/leo/bin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/leo/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/leo/bin/google-cloud-sdk/completion.zsh.inc'; fi

export PATH="${PATH}:/home/leo/anaconda3/bin"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# source ~/.config/lf/lfcd.sh
source ~/.config/lf/lfc.sh
alias r='/mnt/da/Dropbox/scripts/hack lfcd.sh'

# Spark configures
#export SPARK_PATH=~/bin/spark
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk/
#export HADOOP_HOME=~/bin/hadoop-2.10.0
#export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native/
#export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
#export PYSPARK_DRIVER_PYTHON="/usr/bin/anaconda3/bin/jupyter"
#export PYSPARK_DRIVER_PYTHON_OPTS="lab --browser=firefox"
export PATH=$PATH:/opt/apache-spark/bin

tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

t() {tm $(echo $(tmux ls | awk -F ':' '{print $1}') $(seq 0 9) | sed 's/ /\n/g' | sort | uniq -u)}

tmk () {
    local sessions
    sessions="$(tmux ls|fzf --exit-0 --multi)"  || return $?
    local i
    for i in "${(f@)sessions}"
    do
        [[ $i =~ '([^:]*):.*' ]] && {
            echo "Killing $match[1]"
            tmux kill-session -t "$match[1]"
        }
    done
}

fp() {
	file=`find -name "*.pdf" -type f | parallel fzfpdf.sh {} | fzf --preview 'pdftotext $(cut -d ":" -f1 <<< {}) -' | cut -d ":" -f1`
	echo $file
	zathura $file --fork
}


fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}


pk() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}

rgpy() {
	rg "$1" --color=always --line-number --glob *.ipynb
	rg "$1" --color=always --line-number --glob */*.ipynb
	rg "$1" --color=always --line-number --glob */*/*.ipynb
	rg "$1" --color=always --line-number --glob *.py
	rg "$1" --color=always --line-number --glob */*.py
	rg "$1" --color=always --line-number --glob */*/*.py
}

rgdo() {
	rg "$1" --color=always --line-number --glob *.do
	rg "$1" --color=always --line-number --glob */*.do
	rg "$1" --color=always --line-number --glob */*/*.do
}

rg1() {
	rg "$1" --color=always --line-number --max-depth 1
}

eval $(starship init zsh)
eval "$(zoxide init zsh)"
