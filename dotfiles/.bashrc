export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="/usr/bin:$PATH"
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set -o vi
bind -m vi-insert "\C-l":clear-screen

## Modules
configs="$HOME/.config/bashconfigs/"
# Environment variables
source "$configs/env.sh"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

#### ALIAS
alias ll="ls -alh"
alias net="nmtui"

alias fm="yazi"

alias stat="btop"

alias hypr="start-hyprland"

##################################
### custom functions
ff() {
  clear
}

quote() {
  fortune -a | fmt -80 -s | $(shuf -n 1 -e cowsay cowthink) -$(shuf -n 1 -e b d g p s t w y) -f $(shuf -n 1 -e $(cowsay -l | tail -n +2)) -n
}

dev() {
  cd /media/dev
}

personal() {
  cd /media/personal
}

work() {
  cd /media/work
}

collage() {
  cd /media/collage
}

# badapple(){
# cd ~/funs/Bad-Apple-Terminal
# npm start
# }

run_pgadmin() {
  cd ~/pgadmin4
  echo "Activating python virtual environment"
  source venv/bin/activate
  echo "virtual environment activated " $VIRTUAL_ENV
  which python
  sleep 3
  python3 web/pgAdmin4.py
}

# ── Odysseus server ──
odys() {
  cd /home/vedhan/odysseus
  python3 -m venv venv
  source venv/bin/activate
  python -m uvicorn app:app --host 127.0.0.1 --port 7000
}

eval "$(starship init bash)"
# Set up fzf key bindings and fuzzy completion
#eval "$(fzf --bash)"

# Execute on shell load
neofetch

# opencode
export PATH=$HOME/.opencode/bin:$PATH

# ── CLI scripts ──
CLI_DIR="/home/vedhan/Downloads/Lib/2. Areas/CLI"

idvsrv() { (cd "$CLI_DIR" && python3 ideaverse_server.py "$@"); }
synth2.5() { (cd "$CLI_DIR" && python3 synth2.5.py "$@"); }
synth3.5() { (cd "$CLI_DIR" && python3 synth3.5.py "$@"); }
thinkr1() { (cd "$CLI_DIR" && python3 thinkr1.py "$@"); }

eval "$(starship init bash)"
