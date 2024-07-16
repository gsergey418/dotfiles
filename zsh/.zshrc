
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

export EDITOR="nvim"

export PATH="/home/user/.local/bin:$PATH"

export ZVM_VI_SURROUND_BINDKEY=s-prefix

if [ -z "$TMUX" ]; then
    export TERM=xterm-256color
fi

alias ls='ls --color=auto'
alias ll='ls -la'
alias l.='ls -d .* --color=auto'

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
autoload -Uz compinit && compinit
