# Shells open with: command
# login -fpql <whoami> /bin/bash

### Bash init

# Interactive shell setup
if [[ $- == *i* ]]; then
  cd ~/Desktop

  # Set up the Terminal colors
  red=$(tput setaf 1)
  green=$(tput setaf 2)
  yellow=$(tput setaf 3)
  blue=$(tput setaf 4)
  magenta=$(tput setaf 5)
  cyan=$(tput setaf 6)
  reset=$(tput sgr0)

  export CLICOLOR=1
  export LSCOLORS=GxFxCxDxBxegedabagaced

  export PS1="\[$red\]\h \[$blue\]\w \[$green\]> \[$reset\]"
fi

### Frequently Used
alias edit_profile="open ~/.bash_profile -a 'Sublime Text'" # Edit this file
alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
alias sub="subl ." # Open working directory in Sublime Text
alias tower="gittower ."
alias cargo="ruby ~/Documents/Development/cargo.rb/cargo.rb"
alias Procme="ruby ~/Documents/Development/Scripts/procme.rb"
alias notify="terminal-notifier -message 'Task done'"

# Xcode/Swift
alias xc="open *.xcworkspace"
alias se="swiftenv"

# Rails
alias ss="MASTER_PASSWORD=testtest SKIP_PROFILE=1 bundle exec rails server -b 0.0.0.0 -p 3000"
alias sc="bundle exec rails console"

# Quickly cd into project's folder by typing "dev <project>", with autocomplete
function dev() { cd ~/Documents/Development/"$@" ;}

_completeDev()
{
  local files=("/Users/`whoami`/Documents/Development/$2"*)
  [[ -e ${files[0]} ]] && COMPREPLY=( "${files[@]##*/}" )
}

complete -F _completeDev dev

# Open working directory in Finder
alias finder="open ."

# Go to open folder in Finder
function goto() {
  current_path=$(osascript -e 'tell application "Finder" to URL of target of first window' 2>/dev/null)

  if [[ $current_path == file://* ]]; then
    current_path=$(echo "$current_path" | sed 's/file:\/\///g' | sed 's/%20/ /g')
    cd "$current_path"
  else
    cd
  fi
}

# "up <string>" will "cd .." until it finds a directory whose name starts with <string>
function up() {
  starting_point=$PWD
  current_folder=`basename "$PWD"`
  while [[ $current_folder != "$@"* ]]
  do
    cd ..
    current_folder=`basename "$PWD"`
  done

  if [[ $starting_point == $PWD ]]; then
    cd ..
  fi
}

# Open file in Sublime Text, wait until it's closed, then prompt for bundle/pod install
# Autocompleted if the file exists so it's even more convenient!
alias Podfile="_rubyconffile Podfile"
alias Podfile.lock="_rubyconffile Podfile.lock"
alias Gemfile="_rubyconffile Gemfile"
alias Gemfile.lock="_rubyconffile Gemfile.lock"
alias Cartfile="_rubyconffile Cartfile"
alias Cartfile.resolved="_rubyconffile Cartfile.resolved"

function _rubyconffile() {
  current_directory=$(pwd)

  if [ -e "$1" ]; then
    subl -w "$1"
  else
    goto

    if [ -e "$1" ]; then
      subl -w "$1"
    else
      cd "$current_directory"
      subl -w "$1"
    fi
  fi

  if [[ "$1" == "Gemfile" ]]; then
    ruby -e "require 'inquirer'; system('bundle') if Ask.confirm('Run install?')"
  elif [[ "$1" == "Podfile" ]]; then
    ruby -e "require 'inquirer'; install = Ask.confirm('Run install?'); if install; open = Ask.confirm('Open project?'); system('pod install'); system('open *.xcworkspace') if open; end"
  fi
}

### Rarely Used
# Fix "Open with" list by removing duplicates
alias fixopenwith="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user"

# FTP Service
alias startftp="sudo -s launchctl load -w /System/Library/LaunchDaemons/ftp.plist"
alias stopftp="sudo -s launchctl unload -w /System/Library/LaunchDaemons/ftp.plist"

# Flush DNS
alias flushdns="sudo killall -HUP mDNSResponder"

# Download a .gitignore file for the specified language
function gi() { curl https://www.gitignore.io/api/$@ ;}

### PATH and ENV vars
export PATH="/Applications/Postgres.app/Contents/Versions/9.4/bin:/usr/local/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export PATH="$PATH:/Applications/VMware Fusion.app/Contents/Library"

complete -C aws_completer aws

export EDITOR="subl -w"
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

source ~/.secret_bash_profile
