# Path to your oh-my-zsh installation.
export ZSH="/home/askew/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="oxide"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

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

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='code'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,

export BROWSER='/usr/bin/firefox-developer-edition'
export PATH=/home/askew/.local/bin:/home/askew/.go/bin:$PATH
export XDG_CONFIG_HOME="$HOME/.config"
export TERM=tmux-256color
export TERMINAL=alacritty
export GOPATH=$HOME/.go

export PAGER='most'
typeset -A hash
source "${XDG_CONFIG_HOME}/zshconfig/history.zsh"
source "${XDG_CONFIG_HOME}/zshconfig/alias.zsh"
source "${XDG_CONFIG_HOME}/zshconfig/functions.zsh"
source "${XDG_CONFIG_HOME}/zshconfig/docker.zsh"

# if [ -x "$(command -v keychain)" ]; then
    # eval "$(keychain --eval --quiet id_rsa)"
# fi
eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID

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
