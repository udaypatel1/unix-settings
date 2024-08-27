
# Opening Prompt
name="cfonts 'welcome uday' --gradient magenta,white --transition-gradient --align 'center'"
eval $name

RPROMPT="%B%F{magenta}[%f%F{white}%D{%L:%M:%S}%f%F{magenta}]%f%b"

# Base Aliases
alias home='cd ~/'
alias restart='source ~/.zprofile'
alias settings='micro ~/.zprofile'
alias dc='cd ~/Documents'
alias dl='cd ~/Downloads'
alias hold='caffeinate -d'
alias web='open -a "Google Chrome"'
alias view='open -a Preview.app'

# System Info
alias ps-port='f() { lsof -i tcp:$1 }; f'

# Git Commands
alias gs='git status'
alias gaa='git add -A'
alias gcm='git commit -m'
alias gac='git add -A; git commit -m'

# Python Virtual Environment Commands
alias venv-init='python3 -m venv .venv; echo "\nPython Virtual Environment: INITIALIZED\n"'
alias venv-start='{source .venv/bin/activate && echo "\nPython Virtual Environment: ACTIVATED\n"} || {echo "\nWARN: Python Virtual Environment is not Initialized\n"}'
alias venv-stop='{deactivate && echo "\nPython Virtual Environment: DEACTIVATED\n"} || {echo "\nWARN: There is no Active environment to Deactivate\n"}'
alias venv-remove='{rm -r .venv && echo "\nPython Virtual Environment: REMOVED\n"} || {echo "\nWARN: There is no [.venv] file to Remove in this Directory\n"}'

# External Library Dependent commands
alias ls='echo "" && LS_COLORS="di=35:fi=37:ln=32:ex=31" gls --color -h --group-directories-first -N'
alias cheats='cd ~/.local/share/navi/cheats'
alias godir='cd $(find . -type d -print | fzf)'
alias sk='rg --files | sk --preview="bat {} --color=always" --preview-window right:75%'
alias search='rg -S'
alias ps-active='lsof -i -n -P | rg LISTEN'

# Append current git branch to prompt if inside a Git repository
function parse_git_branch() {
	branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

	if [ -n "$branch" ]; then
		echo "%B%F{yellow}$branch%f%b"
	fi
}

# Show Python Venv status on prompt
function parse_venv() {

	input="echo $VIRTUAL_ENV"
	result=$(eval "$input")
	
	if [ -n "$result" ]; then
		echo "%B%F{cyan}(venv)%f%b"
	fi
}

# Get commits ahead/behind information for prompt if inside Git repository
function git_ahead_behind() {
	
	branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
	[ -z "$branch" ] && return
	
	upstream=$(git rev-parse --symbolic-full-name --abbrev-ref "@{u}" 2>/dev/null)
	[ -z "$upstream" ] && return
	
	ahead_count=$(git rev-list --count "$upstream..$branch")
	behind_count=$(git rev-list --count "$branch..$upstream")
	
	if [ "$ahead_count" -gt 0 ]	&& [ "$behind_count" -gt 0 ]; then echo " %F{green}+$ahead_count%f %F{red}-$behind_count%f"
	elif [ "$ahead_count" -gt 0 ]; then echo " %F{green}+$ahead_count%f"
	elif [ "$behind_count" -gt 0 ]; then echo " %F{red}-$behind_count%f"
	fi
}

# Display Prompt Information
function prompt_extension() {

	git_branch=$(parse_git_branch)
	is_venv=$(parse_venv)
	git_ahead_behind=$(git_ahead_behind)
	
	if [ -n "$git_branch" ] && [ -n "$is_venv" ]; then
		PS1="%B%F{white}uday-[%F{magenta}%1~%f]%f %B(%b${git_branch}${git_ahead_behind}%B)%b ${is_venv} : "
		
	elif [ -n "$git_branch" ]; then
		PS1="%B%F{white}uday-[%F{magenta}%1~%f]%f %B(%b${git_branch}${git_ahead_behind}%B)%b : "
		
	elif [ -n "$is_venv" ]; then
		PS1="%B%F{white}uday-[%F{magenta}%1~%f]%f ${is_venv} : "
		
	else
		PS1="%B%F{white}uday-[%F{magenta}%1~%f]%b : "
	fi
}

precmd_functions+=(prompt_extension)
