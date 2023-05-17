# Use <Up> and <Down> for search in history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
# Give colors to default prompt
PS1=\
"\[\e[0m\]"\
"["\
"\[\e[1;34m\]"\
"\u"\
"\[\e[22;39m\]"\
"@"\
"\[\e[1;35m\]"\
"\h"\
"\[\e[22;39m\]"\
" "\
"\[\e[1;32m\]"\
"\w"\
"\[\e[22;39m\]"\
"]\$ "\
"\[\e[0m\]"
