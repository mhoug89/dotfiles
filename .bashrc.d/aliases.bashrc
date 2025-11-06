# grep variants:
alias grep='\grep ${LS_COLOR_FLAG}'
alias fgrep='\fgrep ${LS_COLOR_FLAG}'
alias egrep='\egrep ${LS_COLOR_FLAG}'
# grep with context
alias cgrep='\grep ${LS_COLOR_FLAG} -C 2'

# These are about the only `date` formats I use.
alias date_day='TZ=":America/Los_Angeles" date +%Y-%m-%d'
alias date_sec='TZ=":America/Los_Angeles" date +%Y-%m-%d-%H-%M-%S'
# I use this as shorthand for starting a new Git branch; the abbreviation
# stands for "git new branch". I'll type gnb into my terminal, hit ctrl+alt+e
# to expand the alias, and then type the rest of the branch name that comes
# after the date-related prefix.
alias gnb='git switch -c c$(date_day)-'

alias du_custom='du -kch --max-depth=1 | sort -n'

# ls variants:
# Enable color support of ls and also add handy aliases.
if [ -x /usr/bin/dircolors ] ; then
  eval "`dircolors -b`"
  LS_COLOR_FLAG="--color=auto"
else
  LS_COLOR_FLAG="-G"
fi
alias ls='\ls ${LS_COLOR_FLAG}'
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -lAh'
alias ls_recent_mod='ls -lt'
alias ls_recent_create="stat -c '%W %n' * | sort -k1n"

if type pygmentize >/dev/null 2>&1 ; then
  alias pygcat='pygmentize -g -O style=github-dark'
fi
