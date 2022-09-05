
# CREDITS
# rkj-repos zsh theme: https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/rkj-repos.zsh-theme
# Lucassperez: https://gist.github.com/lucassperez/bc04afa332c18ab708a084c1be1ff230

# FEATURES
# Current git branch
# Color coded branch name: 
## green [clean]
## yellow [unstaged changes or untracked files present]
## cyan [staged changes]
## white [other]
# Git commit short sha
# Last return-code if non-zero
# Full present working directory
# Configurable display of RPROMPT: set disable_rprompt="true" in .zshrc BEFORE theme

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'

git_color() {
  local git_status="$(git status 2> /dev/null)"
  local output_styles=""

  if [[ $git_status =~ "nothing to commit, working tree clean" ]]; then
    # red
    output_styles="green"
  elif [[ $git_status =~ "nothing added to commit but untracked files present" || $git_status =~ "no changes added to commit" ]]; then
    # yellow
    output_styles="yellow"
  # elif [[ $git_status =~ "no changes added to commit"  ]]; then
  #   # yellow
  #   output_styles="yellow"
  elif [[ $git_status =~ "Changes to be committed" ]]; then
    # cyan
    output_styles="cyan"
  else
    output_styles="white"
  fi
  output_styles="%F{$output_styles}$1%f"

  echo "$output_styles"
}

function mygit() {
  if [[ "$(git config --get oh-my-zsh.hide-status)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
    if [[ $ref =~ "fatal" ]]; 
    then
      echo ""
    else
      echo "%{$fg[red]%}-%{$fg[red]%}[%b%{$reset_color%}λ $(git_color ${vcs_info_msg_0_}) $(git_prompt_short_sha)%{$fg[red]%}]"
    fi
  fi
}

# alternate prompt with git
PROMPT=$'%{$fg[red]%}┌─[%{$reset_color%}%{$fg[white]%}%n%b%{$fg[yellow]%}@%{$fg[cyan]%}%m%{$fg[red]%}]%{$fg[red]%}$(mygit)-%{$fg[red]%}[%{$reset_color%}%{$fg[green]%}%~%{$fg[red]%}]
%{$fg[red]%}└─[%{$fg[magenta]%}%0(?..%?)%{$fg[red]%}] %{$fg[yellow]%}\$%{$reset_color%} '
if [[ $disable_rprompt != true ]]; then
  RPROMPT=$'%{$fg[red]%}[%b%{$fg[yellow]%}'%D{"%Y-%m-%d %I:%M:%S"}%b$'%{$fg[red]%}]%{$reset_color%}'
fi
PS2=$' \e[0;31m%}%B   >%{\e[0m%}%b '
