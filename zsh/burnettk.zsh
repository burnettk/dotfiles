case $- in
*i*)    # do things for interactive shell
        echo "sourced .yadr/zsh/burnettk.zsh"
        ;;
*)      # do things for non-interactive shell
        ;;
esac

export DOTFILES=~/.yadr/zsh

# setup environment variables
#export PATH=/usr/local/share/python:$PATH # see `brew info python` for why i do this
export PATH=/usr/local/share/npm/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=~/.cabal/bin:$PATH
export NODE_PATH=/usr/local/lib/node_modules:$NODE_PATH
export R_HOME=/Library/Frameworks/R.framework/Resources

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export EDITOR=vim

alias deletefromtoday='find `pwd` -mtime -1 -type f -print; echo sleeping for 5 seconds and then doing; sleep 5; find `pwd` -mtime -1 -type f -print | xargs rm'

# git
alias gb='git branch -a'
alias gcb='git branch -a | grep "*"' # if there are too many branches, at least this will show the current branch
alias gs='git status'
alias gad='git add .'
alias gd='git diff'
alias gp='git pull'
alias gf='git fetch'
function gnb() {
  git checkout -b $1
}

alias gcm='git checkout master'

# svn
alias sl="svn log --limit 100 | less"
alias ext="svn propedit svn:externals ."
alias ig="svn propedit svn:ignore ."
alias svnst='svn st | egrep -v '\''^(X|Performing)'\'' | egrep -v '\''^$'\'' | egrep -v \.swp'
alias st='svn st --ignore-externals | egrep -v "^X      " | egrep -v \.swp'
alias revertall='echo reverting everything in svn working copy; svnst | sed -e "s/[?\!]  +   //g" | sed -e "s/[?\!]\s*//g" | xargs rm -rf'
alias u='run "svn up"'
alias uu='run "svnupparallel"'
alias recommit='run "svn ci -F svn-commit.tmp; rm svn-commit.tmp"'
alias xxx='echo finding number of svn externals...; svn stat | grep "Performing status on external item" | wc -l | awk "{ print $2 }"' # ollc's what
function ci() {
  svn ci -m "work item $1. $2"
}
function ciw() {
  svn ci -m "wax work item $1. $2"
}
function gosvn () {
  svnst | grep '?' | sed -e 's/?      //g'  | xargs svn add;  svnst | grep '!' | sed -e 's/!      //g' | xargs svn rm # function: gosvn
}

function changed () {
  ADDED=`svn di | egrep '^\+' | wc -lm`
  DELETED=`svn di | egrep '^\-' | wc -lm`
  ADDED_LINES=`echo $ADDED | awk '{ print $1 }'`
  DELETED_LINES=`echo $DELETED | awk '{ print $1 }'`
  ADDED_CHARACTERS=`echo $ADDED | awk '{ print $2 }'`
  DELETED_CHARACTERS=`echo $DELETED | awk '{ print $2 }'`
  echo "Stats for working copy:"
  echo "Added lines: $ADDED_LINES"
  echo "Deleted lines: $DELETED_LINES"
  echo "Added characters: $ADDED_CHARACTERS"
  echo "Deleted characters: $DELETED_CHARACTERS"
  echo "Net change in lines: `expr $ADDED_LINES - $DELETED_LINES`"
  echo "Net change in characters: `expr $ADDED_CHARACTERS - $DELETED_CHARACTERS`"
}

# various crap
alias netcatftw="cat one | nc -v place.example.com 9000" # one should include a POST with all the http headers, like you'd get from following a wireshark tcp stream
alias s='echo source $DOTFILES/burnettk.zsh'
alias d='echo ./script/server; ./script/server'
alias p='echo ./script/server webrick -p 3000 -e production; ./script/server webrick -p 3000 -e production'
alias mine='mysql -uroot'
alias mysqlstart='launchctl load -w ~/Library/LaunchAgents/com.mysql.mysqld.plist' # or mysql.server start
alias mysqlstop='launchctl unload -w ~/Library/LaunchAgents/com.mysql.mysqld.plist' # or mysql.server stop. or mysqladmin -uroot shutdown
alias deleteallrediskeys='redis-cli KEYS "*" | xargs redis-cli DEL'

alias apache='sudo apachectl restart'
alias ctags='/usr/local/bin/ctags'
alias unscrewgems='gem list | cut -d" " -f1 | xargs sudo gem uninstall -aIx -i/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8; gem list | cut -d" " -f1 | xargs sudo gem uninstall -aIx -i/Library/Ruby/Gems/1.8; gem list | cut -d" " -f1 | xargs gem uninstall -aIx'
alias screwallgems='for i in `gem list|cut -d " " -f1`; do echo $i; done > /tmp/gem_list.txt; echo "stored /tmp/gem_list"; for gemname in `gem list|cut -d " " -f1`; do loc=`gem list $gemname -d |grep "Installed at" | cut -d ":" -f2 | sed -e "s/^ //g"`; echo "waxing $gemname from $loc"; sudo gem uninstall -aIx -i$loc $gemname; done'
function wiki() {
  dig +short txt $1.wp.dg.cx
}
alias to='top -ocpu -Ovsize' # top with processes sorted by cpu then by memory
alias rabbit="launchctl start com.rabbitmq.rabbitmq-server"
alias sci='ssh-copy-id -i ~/.ssh/id_rsa.pub' # user@host

# meta
function set_title_to () { 
  echo
  # echo "not setting title to $1"
}

# google contacts processing
#cat contacts.csv | awk --field-separator=, '{print $1, $3, $14 $19 $21}' | sed -e 's/" Mobile: //g' | sed -e 's/" Home: //g' | grep -v "^$" | grep -v '^"' | grep -v Name | sed -e 's/  / /' > contacts.txt

# finding things
alias grepall="find -printf '\"%p\"\n' | grep -v 'svn' | grep -v '~' | grep -v log | xargs grep"

function allincluding() {
  vi `grep -rl $1 * | grep -v svn`
}

# searches and replaces test in all files under the current working directory based on two arguments. usage# perlsr real_time very_fast
function perlsr() {
  perl -pi -e "s/$1/$2/g" `find ./ -type f | fgrep -v .svn | grep -v .git`
}

function openall() {
  vim `find . | grep $1 | grep -v \.svn`
}

unalias g >/dev/null 2>/dev/null
function g () { grep -r "$1" * | grep -v "Binary file " | grep -v \.svn | grep -v \.min\.js | grep -v tmp\/ | egrep -v "^target/"; }

function rg () {
  find . -type f -follow -print -o -type d -name .svn -prune -o -type d -name log -prune -o -type d -name doc -prune -o -type d -name rails -prune -o -type d -name po -prune | xargs grep -si $1 | grep -v "Binary file" | grep -v "web-apps-old" | less
}


function refpl () { 
  #find ./ -type d | fgrep -v .svn | sed -e "s|^|rename -n 's/$1/$2/' |" -e 's|$|/*|' | bash | sed -e 's|^|svn mv |' -e 's| renamed as||' -e 's| would be renamed to||'
  # without the ./ might not work, but looks better
  find . -type d | fgrep -v .svn | sed -e "s|^|rename -n 's/$1/$2/' |" -e 's|$|/*|' | bash 2>&1 | sed -e 's|^|svn mv |' -e 's| renamed as||' -e 's| would be renamed to||'
}
# perl search and replace with named capture: perl -pi -e "s/define_api_method :(?<method_name>\w+)/# def $+{method_name}\n  define_api_method :$+{method_name}/g" *

# rename files. see refpl above.
#for i in `find . | grep file_a | grep -v svn | grep -v swp`; do new_file=`echo $i| sed -e "s/file_a/file_b/g"`; echo "svn mv $i $new_file" | bash; done;

# rvm
alias getrvm='bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )'
alias uprvm='rvm get latest'
alias rr='rvm info'
alias 9='rvm use 1.9.2'
alias 7='rvm use 1.8.7'
alias bu='rvm use 1.8.7@bundler'
alias installgems='gem install passenger tidy rmagick mongrel ruby-debug bundler; env ARCHFLAGS="-arch x86_64" gem install mysql'
alias indexlocatedb='sudo /usr/libexec/locate.updatedb'

# bundler
function be () {
  if [ -f "bundle" ]; then
      ./bundle exec $@
  else
      bundle exec $@
  fi
}

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# general goodness
alias l='ls -ltrG'
alias ll='ls -l' # for chu and those of his persuasion
alias cd..='cd ..'
alias c1='cd ..'
alias c2='c1; c1'
alias c3='c2; c1'
alias c4='c3; c1'
alias sr='run "screen -R"'
alias nano='nano -d' # so nano's backspace works
alias lvi="vi -c \"normal '0\""
function gal () { echo grep "$1" $DOTFILES/burnettk.zsh; grep "$1" $DOTFILES/burnettk.zsh; }

# don't throw duplicate commands, plain ls's, fg's, bg's or exit's into the command history
export HISTIGNORE="&:ls:[bf]g:exit"

export LESS='--RAW-CONTROL-CHARS --force' # make less keep it more real with colors and not asking if i want to open a file i just opened

# vim 

# opens a file with vi and checks the ruby syntax afterwards to make sure you didn't hose it.
function v () { 
  vim "$1";
  expr "$1" : '.*\.rb' > /dev/null && echo checking ruby syntax... && ruby -c "$1";
}

alias vi='vim'

alias vundle='vim +BundleInstall +qall'

# rails
function m () {
  if [ -z $1 ]; then
    echo ./rake db:migrate;
    ./rake db:migrate;
  else
    echo ./rake db:migrate VERSION=$1;
    ./rake db:migrate VERSION=$1;
  fi
}

alias tl='run "tail -f log/development.log"';
alias lel='run "less log/development.log"';
alias letl='run "less log/test.log"';
alias se='run "./rake setup:explode"'
alias rlc='run "./rake log:clear"'
alias tailtest='run "tail -f log/test.log"'
alias taildev='run "tail -f log/development.log"'
alias slave='./rake mysql production-slave'

# rails tests
alias r='run "./rake"'
alias rtu='run "./rake test:units"'
alias un='rtu'
alias rtf='run "./rake test:functionals"'
alias fu='rtf'
alias rti='run "./rake test:integration"'
alias rtp='run "./rake test:pre_commit"'
alias rts='run "./rake test:selenium"'
alias rtj='run "./rake test:javascript"'

# jabber
alias jabberstart='sudo ejabberdctl start'
alias jabberstop='sudo ejabberdctl stop'
alias jabberstatus='sudo ejabberdctl status'

# miscellaneous
alias myps='ps uawx | egrep "^`whoami | sed -e '\''s/^\([a-z]\{1,8\}\).*/\1/'\''`"' # jeffmo and robbyl collaboration
alias myip='run "ifconfig | grep 10.40"' # sometimes does what you want
alias analyze='echo most used commands:; cut -f1 -d" " .bash_history | sort | uniq -c | sort -nr | head -n 30'
function whatsonport() {
  sudo lsof -i :$1
}
# ' #80 # checks port 80

# running "die 3000" kills any processes you own with '3000' in the command (like webrick processes you started with ./script/server -p 3000)
function die () {
  echo "killing any processes i own that include: $1"
  # checks for zero length string
  if [ -z "`ps xu | grep "$1" | grep -v grep`" ]; then
    echo No processes found
  else
    echo "these processes are getting waxed:"
    ps xu | grep "$1" | grep -v grep
    ps xu | grep "$1" | grep -v grep | awk '{ print $2 }' | xargs kill -9
  fi
}

# outputs the command and then runs it!
function run () { 
  echo "$*"
  eval "$*"
}

# apache with passenger
alias ra='run "touch tmp/restart.txt"'

# npm install javascript-ctags
alias jctags='javascript-ctags "**/*.js"'

function searchskypefor() {
  echo "select * from Messages where body_xml like '%$1%';" | sqlite3 ~/Library/Application\ Support/Skype/*/main.db
}

alias lintallchangedjsfiles='for i in `git diff --name-only`; do if [ "${i}" != "${i%.js}" ]; then jsl -process $i; fi; done'

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
