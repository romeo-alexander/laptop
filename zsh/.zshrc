############################ 1. Core bootstrap ############################
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

# Path modifications
path=(
  "$HOME/bin"
  "$HOME/go/bin"
  $path
)
export PATH

# Completion cache lives outside $HOME
ZCACHEDIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZCACHEDIR"
export ZSH_COMPDUMP="$ZCACHEDIR/zcompdump-${HOST}-${ZSH_VERSION}"
zstyle ':completion:*' use-cache on   # tells compinit to respect the cache
zstyle ':completion:*' menu select

# Custom completion/functions
[[ -d $HOME/.zfunc ]] && fpath+=("$HOME/.zfunc")

############################ 2. Oh-My-Zsh #################################
ZSH_THEME=""                 # prompt handled by starship
plugins=(git direnv)
source "$ZSH/oh-my-zsh.sh"

############################ 3. Prompt, key-bindings, aliases #############
eval "$(starship init zsh)"
set -o vi
source ~/.zaliases

############################ 4. Secrets & project env #####################
[[ -f $HOME/.config/env/secrets.zsh ]] && source "$HOME/.config/env/secrets.zsh"

# CLAUDE
export BASH_DEFAULT_TIMEOUT_MS=600000
export BASH_MAX_TIMEOUT_MS=600000
export MAX_THINKING_TOKENS=16000

eval "$(direnv hook zsh)"


# --- Silent "copy last cmd" widget ------------------------------------
copy_last_cmd_widget() {
  print -rn -- "$history[$((HISTCMD-1))]" | pbcopy
}
zle -N copy_last_cmd_widget

# Bind the widget to Ctrl-g in *both* vi-insert and vi-command modes
bindkey -M viins '^G' copy_last_cmd_widget
bindkey -M vicmd '^G' copy_last_cmd_widget

eval "$(fnm env --use-on-cd)"
