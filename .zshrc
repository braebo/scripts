#!/bin/zsh

##? p10k ##

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of $HOME/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

function p10k-on-pre-prompt() {
	if (( COLUMNS < 80 )); then
		p10k display '*/context'=hide
	else
		p10k display '*/context'=show
	fi
}


##? ZSH ##

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=powerlevel10k/powerlevel10k
plugins=(git macos last-working-dir fzf zsh-navigation-tools)
source $ZSH/oh-my-zsh.sh


##? Keybinds ##

# Terminal alt+left/right arrow keys move cursor by word.
bindkey "\e\e[D" backward-word
bindkey "\e\e[C" forward-word
# Terminal alt+backspace delete word.
bindkey '^H' backward-kill-word
# Terminal alt+delete delete word.
bindkey '^[[3;3~' kill-word


##? Scripts ##

export SCRIPTS="$HOME/dev/scripts"
export COLOR="$SCRIPTS/global/color.sh"

source $SCRIPTS/source.sh


##? Aliases ##

alias hax="code $HOME/.zshrc"												# open this file in vscode
alias haxx="code $HOME/.p10k.zsh"											# open .p10k config in vscode
alias scripts="code ~/dev/scripts"											# open the scripts directory in vscode
alias o="open ."															# This is unhealthy.
alias pwdc="pwd | tr -d '\n' | pbcopy && echo 'pwd copied to w'"			# Copy CWD to w.
alias pg="sudo -u postgres -i && postgresql"								# Activate Postgres.
alias blender="$HOME/../../Applications/Blender.app/Contents/MacOS/Blender" # Launch Blender with stdout.
alias c="clear"																# Clear the terminal.
alias rl="exec $SHELL"
alias reload="source $HOME/.zshrc"
alias ohmyzsh="code $HOME/.oh-my-zsh"
alias k8="kubectl"															# devops engineer roleplay
alias tc="tree -c -L 1 -C"													# tree level 1	↓ date modified
alias t="tree -L 1 -C"														# tree level 1
alias t2="tree -L 2 -C"														# tree level 2
alias t3="tree -L 3 -C"														# tree level 3
alias t4="tree -L 4 -C"														# tree level 4
alias gppm="git push production main"										# push to production
alias gppmc="git rev-list --count production/main..origin/main"				# count commits ahead of production
alias gpp="git pull production main; git push; echo '\n✅ Pulled main from production and pushed main to origin.\n'" # pull production and push origin
alias kys="killall SpeechSynthesisServer"									# kill macos voice
alias show="defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder" 	# show hidden files (MacOS)
alias hide="defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder" 	# hide hidden files (MacOS)
alias awesome="awesome-hub"
alias tunnel='tunnel() { cloudflared tunnel --url http://localhost:${1:-5173}; }; tunnel'
alias yt="youtube"
alias ports="sudo lsof -i -P | grep LISTEN" # List open ports and their process id
alias fracflix="echo '
🤖 FracBOT initializing FracFLIX....
	.,,,,,,,,,,,,.*,,,,,,,,,,. ,       *,,,,,,,,*      *.,,,,,,,,.,  . ,,,,,,,,,,,,,..,,,,,*       *,,,,,.  ,,,,,.    . ,,,,
	,************. *************,*    . ******** .   . ************...,************, ,*****         *****,. *****,*  ..*****
	,************, **************,*   ..********..    ******..,*****...************, ,*****         *****,.. *****.   *****,.
	,****,.        *****,. ,,*****     **********   ..***** . .,****,.,*****        .,*****         *****,. .,***** .,****,.
	,****,.        *****,. .,*****   ..**** ,****.. . ***** .  ,****...*****        .,*****         *****,.  .*****,.*****
	,****,.        *****,. ..*****   *,**** ,****,* . ***** . ..****...*****        .,*****         *****,.  . ********** .
	,****,,. ....  *****..,,***** .   ***** ******  ..***** .        ..*********** ..******         *****,    .,********,.
	,**********,   ************,,.  ..****,* *****, . ***** .        ..*********** ..,*****         *****,.    .,*******
	,**********,   **************.  .,**** . ,****, . ***** . ..,,,,..****** ...... .,*****         *****,.   ..********.
	,****...,,,,   *****,,* ,*****   *****.,,,***** . ***** . .,****,.,*****        .******         *****,.  ..**********
	,****,.        *****,. .,***** .,**************..****** . .,****,..*****        .,*****         *****,.  .***** *****,,
	,****,.        *****,. .,*****  ,********,******  *****, ,.*****,*,*****        .,***** *.      *****,. ,*****,. *****..
	,****,.        *****,. .,*****  *****    .****** ,,************,..,*****        .,************* *****,...***** ..,****,
	,****,.        *****,. .,***** ,****,.     *****... ,*********.. .,*****        ..************* *****,. *****,* . *****..
	,****,.        *****,* ..**,,,.......      ,,,*..    .,,,,,,.         ..         ,,........,,,,.*****, ,****,    *,*****
	,****,*       *,,,,.                                                                                   ,,,....    .*****,
	 ,,,.                                                                                                               .,,,
' && cliflix"

alias settings="ci $HOME/Library/Application\ Support/Code\ -\ Insiders/User"
alias qrlocal='echo "http://$(ipconfig getifaddr en0):5173" | qrencode -t ASCII'
alias qrtailscale='echo "http://$(tailscale ip | head -n 1):5173" | qrencode -t ASCII'
alias ip="ipconfig getifaddr en0"   # Print IP.
alias i="pnpm install"
alias ipd="pnpm install && pnpm dev"
alias pu="pnpm update --latest"
alias d="pnpm dev"
alias bd="bun dev"
alias pd="pnpm dev"
alias pdhl="qrlocal && pd --host"
alias pdh="qrtailscale && pd --host"
alias pb="pnpm build"
alias pp="pnpm package"
alias ppr="pnpm preview"
alias pt="pnpm test"
alias pc="pnpm check"
alias pcw="pnpm check:watch"
alias ptui="pnpm test:ui"
alias bump="pnpm up --config.strict-peer-dependencies=false --latest -r"
## Trash & Dev (pnpm)
alias ry="trash node_modules package-lock.json pnpm-lock.yaml dist public/build && pnpm i && pnpm dev"
## "ReDev" (pnpm)
alias rd="trash node_modules package-lock.json pnpm-lock.yaml dist && pnpm i && pnpm dev"
## "ReBuild" (pnpm)
alias rb="trash node_modules pnpm-lock.yaml package-lock.json dist && pnpm i && pnpm build"
alias psort="pnpx sort-package-json"
alias ts="pnpx typesync"
## Trash all dev directories.
alias ta="trash pnpm-lock.yaml node_modules .svelte-kit"
alias vercel-logs='vercel logs "$(vercel ls | grep -o "^[^ ]*" | head -1)" -f'

# List vercel deployments and tail the latest one.
function vercel-tail() {
  echo -e "\033[0;35mLatest vercel deployment logs\n\033[0m"
  vercel list
  url=$(vercel list 2>/dev/null | grep -o 'https://[^ ]*' | head -1)
  vercel logs "$url" -f
}

## Spotify Controls ##
alias spot="spotify status"
alias play="spotify play"
alias stop="spotify stop"

## Spyware Zapper ##
alias fuckadobe='
sudo pkill "Adobe Desktop Service";
sudo pkill "AdobeCRDaemon";
sudo pkill "AdobeIPCBroker";
sudo pkill "CCXProcess";
sudo pkill "Core Sync";
sudo pkill "Core Sync Helper";
sudo pkill "Creative Cloud Helper";
echo "💥 Killed Adobe Spyware";'

# Prettier config.
alias prc='
echo -e """{\n\t\n\t\"trailingComma\": \"all\",\n\t\"requirePragma\": false,\n\t\"bracketSpacing\": true,\n\t\"singleQuote\": true,\n\t\"printWidth\": 80,\n\t\"useTabs\": true,\n\t\"tabWidth\": 4,\n\t\"semi\": false\n}""" >> .prettierrc;
echo "Created .prettierrc 🌷";
cat .prettierrc;
'


##? Web Search https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/web-search/web-search.plugin.zsh

function web_search() {
	emulate -L zsh

	# define search engine URLS
	typeset -A urls
	urls=(
		# $ZSH_WEB_SEARCH_ENGINES
		google			"https://www.google.com/search?q="
		bing			"https://www.bing.com/search?q="
		duckduckgo		"https://www.duckduckgo.com/?q="
		github			"https://github.com/search?q="
		stackoverflow	"https://stackoverflow.com/search?q="
		youtube			"https://www.youtube.com/results?search_query=?q"
	)

	# check whether the search engine is supported
	if [[ -z "$urls[$1]" ]]; then
		echo "Search engine '$1' not supported."
		return 1
	fi

	# search or go to main page depending on number of arguments passed
	if [[ $# -gt 1 ]]; then
		# build search url:
		# join arguments passed with '+', then append to search engine URL
		url="${urls[$1]}${(j:+:)@[2,-1]}"
	else
		# build main page url:
		# split by '/', then rejoin protocol (1) and domain (2) parts with '//'
		url="${(j://:)${(s:/:)urls[$1]}[1,2]}"
	fi

	open_command "$url"
}

alias google='web_search google'
alias github='web_search github'
alias so='web_search stackoverflow'
alias ddg='web_search duckduckgo'
alias wiki='web_search duckduckgo \!w'
alias yt='web_search duckduckgo \!yt'

alias http="httpstat"
export HTTPSTAT_SHOW_IP=false
export HTTPSTAT_SHOW_SPEED=true
export HTTPSTAT_SAVE_BODY=false

# View the latest release notes for a GitHub repo
function changelog() {
	if [[ -z "$1" ]]; then
		echo "Usage: changelog <repo>"
		return 1
	fi

	gh release view -R $1
}

# Open a GitHub repo in the browser
function ghw() {
	if [[ -z "$1" ]]; then
		echo "Usage: ghw <repo>"
		return 1
	fi

	gh repo view $1 --web
}

# Find large files in a directory to avoid github's file size limit
function findLargeFiles() {
	large_files=$(find "$1" -type f -size +29M -print0 | xargs -0 -I {} echo {})
	if [ -z "$large_files" ]; then
		largest_file_info=$(find "$1" -type f -exec stat -f "%z %N" {} + | awk '{if ($1>max) {max=$1; file=$0}} END {print file}')
		largest_file_size=$(echo "scale=2; $(echo "$largest_file_info" | awk '{print $1}') / 1024 / 1024" | bc)
		echo "No large files found. Largest file is ${largest_file_size}MB."
	else
		echo "Large files in $1:"
		echo "$large_files"
	fi
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# j
[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# python
export PATH="/usr/local/opt/python@3.10/libexec/bin:$PATH"

# go
export PATH=$PATH:$HOME/go/bin

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
[ -s "/Users/bew/.bun/_bun" ] && source "/Users/bew/.bun/_bun"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# util-linux for chromium
export PATH="/usr/local/opt/util-linux/bin:$PATH"
export PATH="/usr/local/opt/util-linux/sbin:$PATH"

# depot tools for chromium
# https://chromium.googlesource.com/chromium/src/+/HEAD/docs/mac_build_instructions.md#install
export PATH="$PATH:/usr/local/opt/depot_tools"


# Github Copilot CLI can't be found without the full path to the global pnpm binary.
eval "$($HOME/Library/pnpm/github-copilot-cli alias -- "$0")"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

PATH=~/.console-ninja/.bin:$PATH
