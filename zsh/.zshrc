
function auto_deactivate_python_venv() {
	if (( $+functions[deactivate] )) && [[ $PWD != ${VIRTUAL_ENV:h}* ]]; then
		deactivate > /dev/null 2>&1
	fi
}


function auto_source_python_venv() {
	if [[ $PWD != ${VIRTUAL_ENV:h} ]]; then
		for _file in venv/bin/activate(N.); do
			(( $+functions[deactivate] )) && deactivate > /dev/null 2>&1
			source $_file > /dev/null 2>&1
			break
		done
	fi
}

function auto_source_poetry_venv() {
  if [[ -f "$PWD/pyproject.toml" ]] && grep -q 'tool.poetry' "$PWD/pyproject.toml"; then
    venv_dir=$(poetry env info --path 2>/dev/null)
    if [[ -n "$venv_dir" ]]; then
      source "${venv_dir}/bin/activate"
    fi
  fi
}

# History file for zsh
HISTFILE=~/.zsh_history

# How many commands to store in history
HISTSIZE=10000
SAVEHIST=10000
# Share history in every terminal session
setopt SHARE_HISTORY

export EDITOR="nvim"

export PATH="/home/user/.local/bin:$PATH"

export ZVM_VI_SURROUND_BINDKEY=s-prefix

bindkey '^H' backward-kill-word

if [ -z "$TMUX" ]; then
    export TERM=xterm-256color
fi

alias ls='ls --color=auto'
alias ll='ls -la'
alias l.='ls -d .* --color=auto'

alias vim='nvim'

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

eval "$(starship init zsh)"

source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

autoload -U add-zsh-hook

add-zsh-hook chpwd auto_deactivate_python_venv
add-zsh-hook chpwd auto_source_python_venv
add-zsh-hook chpwd auto_source_poetry_venv

auto_deactivate_python_venv
auto_source_python_venv
auto_source_poetry_venv

fpath+=~/.zfunc
fpath+=~/.config/zsh/completions/
autoload -Uz compinit && compinit
