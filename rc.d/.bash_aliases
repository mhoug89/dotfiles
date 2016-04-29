# curl variants
alias curl-oauth='curl -H "Authorization: Bearer $(gcloud auth print-access-token)"'

# grep variants.
alias grep='\grep ${LS_COLOR_FLAG}'
alias fgrep='\fgrep ${LS_COLOR_FLAG}'
alias egrep='\egrep ${LS_COLOR_FLAG}'
# grep with context
alias cgrep='\grep ${LS_COLOR_FLAG} -C 2'

# ls variants.
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
#alias du='echo "du aliased to:  du -kch --max-depth=1 | sort -n"; du -kch --max-depth=1 | sort -n'

# Parse seconds, milliseconds, and microseconds into readable dates.
if [ -n "$(which parse_xsec)" ]; then
  alias parse_sec='parse_xsec 1'
  alias parse_msec='parse_xsec 1000'
  alias parse_usec='parse_xsec 1000000'
fi

# Conditional aliases, depending on what box I'm on.
if [[ $(hostname -f) == *.cs.mtsu.edu ]] ; then
  # shortcut for firefox fix
  alias fffix='rm -i ~/.mozilla/firefox/petdp121/.parentlock ~/.mozilla/firefox/petdp121 g/lock;rm ~/.mozilla/firefox/petdp121.default/places.sqlite-journal;cp ~/.mozilla/firefox/petdp121.default/places.sqlite ~/.mozilla/firefox/petdp121.default/places.sqlite-journal; rm ~/.mozilla/firefox/petdp121.default/places.sqlite;rm ~/.mozilla/firefox/petdp121.default/.parentlock'
  alias BUTLER='cd ~rbutler/public/courses/'
fi

if [ -d "/cygdrive/c/Users/$USER/Desktop" ] ; then
  alias desktop="cd /cygdrive/c/Users/$USER/Desktop"
fi
