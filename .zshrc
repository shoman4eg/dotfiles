# Path to your oh-my-zsh installation.
export ZSH="/home/askew/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="oxide"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

export XDG_CONFIG_HOME="$HOME/.config"
source "${XDG_CONFIG_HOME}/zshconfig/environments.zsh"
source "${XDG_CONFIG_HOME}/zshconfig/history.zsh"

plugins=(
    git
    zsh-autosuggestions
    extract
    common-aliases
    docker
    docker-compose
    archlinux
    fzf
    zsh-autosuggestions
    # zsh-syntax-highlighting
)


source $ZSH/oh-my-zsh.sh

echo -e -n "\x1b[\x34 q"

# User configuration
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='code'
fi

unalias duf

typeset -A hash
source "${XDG_CONFIG_HOME}/zshconfig/alias.zsh"
source "${XDG_CONFIG_HOME}/zshconfig/functions.zsh"
source "${XDG_CONFIG_HOME}/zshconfig/docker.zsh"

if [ -x "$(command -v dircolors)" ]; then
  eval "$(dircolors -b ~/.config/dircolors)"
fi

dump_file="$HOME/.cache/zsh/zcompdump"
if [[ "$dump_file" -nt "${dump_file}.zwc" || ! -f "${dump_file}.zwc" ]]; then
  zcompile "$dump_file"
fi
if [ -z "$ZSH_COMPDUMP" ]; then
  ZSH_COMPDUMP="$dump_file-${SHORT_HOST}-${ZSH_VERSION}"
fi
unset dump_file

source /home/askew/.config/broot/launcher/bash/br

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
