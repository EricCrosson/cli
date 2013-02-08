# TERMINAL
# -------------------------------------------------------------------------
# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

function reload {
  source ~/.bashrc
}

function title {
  echo -ne "\033]2;$1\007"
}

function setclock {
  rdate -s 129.6.15.28
}

#Directory Colors
LS_COLORS='di=0;32'
export LS_COLORS

#Colors
          RED="\[\033[0;31m\]"
    LIGHT_RED="\[\033[1;31m\]"
       YELLOW="\[\033[0;33m\]"
 LIGHT_YELLOW="\[\033[1;33m\]"
         BLUE="\[\033[0;34m\]"
   LIGHT_BLUE="\[\033[1;34m\]"
        GREEN="\[\033[0;32m\]"
  LIGHT_GREEN="\[\033[1;32m\]"
         CYAN="\[\033[0;36m\]"
   LIGHT_CYAN="\[\033[1;36m\]"
       PURPLE="\[\033[0;35m\]"
 LIGHT_PURPLE="\[\033[1;35m\]"
        WHITE="\[\033[1;37m\]"
   LIGHT_GRAY="\[\033[0;37m\]"
        BLACK="\[\033[0;30m\]"
         GRAY="\[\033[1;30m\]"
     NO_COLOR="\[\e[0m\]"

function prompt_git() {
  local status output flags
  status="$(git status 2>/dev/null)"
  [[ $? != 0 ]] && return;
  output="$(echo "$status" | awk '/# Initial commit/ {print "(init)"}')"
  [[ "$output" ]] || output="$(echo "$status" | awk '/# On branch/ {print $4}')"
  [[ "$output" ]] || output="$(git branch | perl -ne '/^\* (.*)/ && print $1')"
  flags="$(
    echo "$status" | awk 'BEGIN {r=""}
      /^# Changes to be committed:$/        {r=r "+"}
      /^# Changes not staged for commit:$/  {r=r "!"}
      /^# Untracked files:$/                {r=r "?"}
      END {print r}'
  )"
  if [[ "$flags" ]]; then
    output="$output$LIGHT_BLUE$flags$RED"
  fi
  echo "[$output]"
}

HOSTNAME="unknown"
function prompter {
  colwidth=$(tput cols)
  howfardown=$(echo `pwd` | sed 's/[^/]//g')
  if [ $colwidth -lt 120 ]; then
    PS1="$RED\n$(prompt_git)$RED[$HOSTNAME($USER):$howfardown\W]:\e[m "
  else
    PS1="$RED\n$(prompt_git)$RED[$HOSTNAME($USER):\w]:\e[m "
  fi
}
PROMPT_COMMAND="prompter"
# -------------------------------------------------------------------------


# ALIASES
# -------------------------------------------------------------------------
alias rm='rm -i '
alias cp='cp -i '
alias mv='mv -i '

alias ll="ls -l "
alias vi="vim "
# -------------------------------------------------------------------------


# GIT
# -------------------------------------------------------------------------

#git completion
source ~/.git-completion.bash

#aliases
alias hist='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'
alias gst='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '

alias got='git '
alias get='git '
alias groot='cd $(git rev-parse --show-cdup) '

#push current branch (or specified branch) to remote repo "origin"
function gp {
  local status branch
  if [ -z $1 ]; then
    status="$(git status 2>/dev/null)"
    branch="$(echo "$status" | awk '/# On branch/ {print $4}')"
    echo "pushing to origin/$branch"
    git push origin $branch
  else
    echo "pushing to origin/$1"
    git push origin $1
  fi
}

#pull current branch (or specified branch) from remote repo "origin"
function gu {
  local status branch
  if [ -z $1 ]; then
    status="$(git status 2>/dev/null)"
    branch="$(echo "$status" | awk '/# On branch/ {print $4}')"
    echo "pulling from origin/$branch"
    git pull origin $branch
  else
    echo "pulling from origin/$1"
    git pull origin $1
  fi
}
# -------------------------------------------------------------------------


# PROCESS MGMT
# -------------------------------------------------------------------------
function dojob {
  source ~/.jobs/$1
}

function start {
  /etc/init.d/$1 star
}

function restart {
  /etc/init.d/$1 restar
}

function stop {
  /etc/init.d/$1 stop
}

function isrunning {
  ps -ef | grep $1 | grep -v grep
}

function isinstalled {
  rpm -qa | grep -i $1
}
# -------------------------------------------------------------------------


# SED
# -------------------------------------------------------------------------
function dedup {
  sed -i '$!N; /^\(.*\)\n\1$/!P; D' $1
}

function upcase {
  sed -i 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/' $1
}

function downcase {
  sed -i 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/' $1
}

function linecount {
  cat "$1" | grep -c $
}

function unDOS {
  sed -i 's/.$//' $1
}

function noextraspaces {
  sed -i 's/^[ \t]*//;s/[ \t]*$//' $1
}

function notrailinglines {
  sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' $1
}

function noHTML {
  sed -i -e :a -e 's/<[^>]*>//g;/</N;//ba' $1
}

function trailingspaces {
  sed -i '' -e's/[ \t]*$//' $1
}

function doublespace {
  sed -i 'G' $1
}

function safedoublespace {
  sed -i '/^$/d;G' $1
}

function singlespace {
  sed -i 'n;d' $1
}

function blanklinebefore {
  sed -i "/$1/{x;p;x;}" $2
}

function blanklineafter {
  sed -i "/$1/G" $2
}

function reverseline {
  sed -i '/\n/!G;s/\(.\)\(.*\n\)/&\2\1/;//D;s/.//' $1
}

function appendlines {
  sed -e :a -e -i '/\\$/N; s/\\\n//; ta' $1
}
# -------------------------------------------------------------------------


# PORTS
# -------------------------------------------------------------------------
function specificcloseport {
  iptables -D INPUT -p tcp -m state --state NEW -m tcp --dport $1 -s $2 -j ACCEPT
}

function specificopenport {
  iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport $1 -s $2 -j ACCEPT
}

function openport {
  iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport $1 -j ACCEPT
}

function closeport {
  iptables -D INPUT -p tcp -m state --state NEW -m tcp --dport $1 -j ACCEPT
}

function listenports {
  lsof | grep LISTEN
}

# listen for GA activity and print it to the screen
function sniff {
  #tcpdump -ANi en0 'host www.google-analytics.com and port http'
  tcpdump -ANi en0 'host www.google-analytics.com and port http' > ga.log
}
# -------------------------------------------------------------------------


# DIRECTORY AND FILE
# -------------------------------------------------------------------------
function lookat {
  vim -R $1
}

function findtextinfiles {
  find . -name "$1" | xargs grep -n "$2"
}

function save {
  mv $1 $1.saved
}

function restore {
  mv $1.saved $1
}

function follow {
  cat $1; tail -F $1 &
}

function back {
  cd $OLDPWD
}

function lodev {
  cd /Library/WebServer/Documents
}

function dir {
  ls -l | grep ^d
}

function unspacefilenames {
  for f in *; do mv "$f" `echo $f | tr ' ' '_'`; done
}

function wipe {
  rm -R -f $1
}

function clonedirsfrom {
  (cd $1; find -type d ! -name .) | xargs mkdir
}

function copythisdirto {
  cp -r -p -P -u * $1
}

function findtexti {
  grep -n -i -R "$1" * | grep -v svn | grep -v "Binary file"
}

function findtext {
  grep -n -R "$1" * | grep -v svn | grep -v "Binary file"
}

function findstr {
  grep -i -n -R $1 * | grep -v ".svn" | less
}

function randomShuffle {
    touch x;
    while read line
    do
        elements[$length]=$line
        length=$(($length + 1))
    done
    firstN=${1:-$length}
    if [ $firstN -gt $length ]
    then
        firstN=$length
    fi
    for ((i=0; $i < $firstN; i++))
    do
        randPos=$(($RANDOM % ($length - $i) ))
        echo "${elements[$randPos]}" >> x
        elements[$randPos]=${elements[$length - $i - 1]}
    done
}
# -------------------------------------------------------------------------


# FILE PERMISSIONS
# -------------------------------------------------------------------------
function my {
  chown `whoami`:`whoami` $1
}

function owner () {
  chown -R $1 *
  chgrp -R $1 *
}
# -------------------------------------------------------------------------


# FILE COMPRESSION
# -------------------------------------------------------------------------
function addtotar () {
  tar -rf $1 $2
}

function tardate {
  DUMPDATE=`date +%F-%H-%M`;
  tar -vcf ~/$1.$DUMPDATE.tar *
}

function taritup {
  dirname `pwd` > x
  tr x / -
  tarballname=`cat x`
  now=`date +%F`
  tar -zcf ~/$tarball.$now.tar.gz *
}

function untar {
  FT=$(file -b $1 | awk '{print $1}')
    if [ "$FT" = "bzip2" ]; then
      tar xvjf "$1"
    elif [ "$FT" = "gzip" ]; then
      tar xvzf "$1"
    fi
}
# -------------------------------------------------------------------------


# SYM LINK
# -------------------------------------------------------------------------
function reassign {
  if [ -z $1 ]; then
   read -p "Give the name of the link: " linkname
  fi
  if [ -z $2 ]; then
   read -p "Give the name of the new target: " targe
  fi

  # Make sure the thing we are removing is a sym link.
  if [ ! -L $1 ]; then
   echo "Sorry. $1 is not a symbolic link"

  # attempt to create the file if it does not exist.
  else
   if [ ! -e $2 ]; then
     touch $2
     # mention the fact that we had to create it.
     echo "Created empty file named $2"
   fi

   # make sure the target is present.
   if [ ! -e $2 ]; then
     echo "Unable to find or create $2."
   else
     # nuke the link
     rm -f $1
     # link
     ln -s $2 $1
     # confirm by showing.
     ls -l $1
   fi
  fi
}

function symlink {
# $1 is the name of some directory to be replaced by a symlink.
# $2 is the name of directory we want to symlink to, instead.
  mv $1 $1.bak
  ln -s $2 $1
  rmdir $1.bak
}
# -------------------------------------------------------------------------


# USEFUL FRONT-ENDY STUFF
# -------------------------------------------------------------------------
#minification
export minifier=/Applications/Java/yuicompressor-2.4.7/build/yuicompressor-2.4.7.jar

#compile less and then minify ($1 = project name, $2 = if defined, skip the minification)
function lm {
  if [ -z $1 ]; then
    echo "please specify a target .less file: lm {project_name}"
  else
    file="less/$1.less"
    if [ -f $file ]; then
      echo "compiling ${file}"
      lessc less/$1.less > $1-style.css
      if [ -z $2 ]; then
        echo "minfying the css file"
        java -jar $minifier $1-style.css -o $1-style.min.css
        echo "done."
      else
        echo "less compiled (skipping the minification)."
      fi
    else
     echo "target file does not exist! (./less/$file)"
    fi
  fi
}

function min {
  if [ -z $1 ]; then
    echo 'please specify a target: min {target} {target_extension}'
  else
    if [ -z $2 ]; then
      echo 'please specify a file type: min {target} {target_extension}'
    else
      if [ -f $1.$2 ]; then
        echo "performing $2 minification"
        java -jar $minifier $1.$2 -o $1.min.$2
        echo "done."
      else
        echo "can't find ./$1.$2"
      fi
    fi
  fi
}
# -------------------------------------------------------------------------


# PHP
# -------------------------------------------------------------------------
function phperrors {
  tail -100 /var/log/httpd/error_log
}

#check for php syntax errors
function check
{
  if [ -z $1 ]; then
    echo 'Usage: check filename[.php]'
    echo ' performs a syntax check of the file (appending ".php" as needed)'
  else
    if [ -f $1 ]; then
      php -l $1
    elif [ -f $1.php ]; then
      php -l $1.php
    elif [ -f $1php ]; then
      php -l $1php
    else
      echo "Cannot find the file $1"
    fi
  fi
}
# -------------------------------------------------------------------------


# APACHE HTTPD
# -------------------------------------------------------------------------
function addhttpauth {
###
# At long last ... a function to do this.
###
  echo 'Add basic HTTP authentication to a directory. Default values'
  echo 'are shown in [brackets]. This function will create an htaccess'
  echo 'file in a directory for the user/password combo you supply'
###
# get a little info
###
  read -p "Give the name of the directory [this dir]: " dirname
  dirname=${dirname:-`pwd`}
  read -p "User name to access $dirname: [my user]: " username
  username=${username:=`whoami`}
  htaccess=$dirname/.htaccess
  htpasswd=/etc/www/$username/.htpasswd

  read -p "Password for $username: " pass1
  read -p "Repeat the password:    " pass2
  if [ $pass1 != $pass2 ]; then
    echo 'Try again. Those passwords did not match.'
  else
# let's go...
    if [ ! -f $htaccess ]; then
      touch $htaccess
      mkdir -p /etc/www/$username
      echo "AuthUserFile /etc/www/$username/.htpasswd" >> $htaccess
      echo 'AuthName "This site is secured by password."' >> $htaccess
      echo 'AuthType Basic' >> $htaccess
    fi
    echo "require valid-user" >> $htaccess

    if [ ! -f /etc/www/$username/.htpasswd ]; then
      mkdir -p /etc/www/$username
      touch $htpasswd
    fi
    htpasswd -nmb $username $pass1 >> $htpasswd
    chmod 644 $htaccess
    chmod 644 $htpasswd
    chown apache:apache $htpasswd
    chown apache:apache $htaccess
  fi
}
# -------------------------------------------------------------------------


# MYSQL DATABASE
# -------------------------------------------------------------------------
function db {
  if [ -z $1 ]; then
    echo 'specify a database!'
  else
    if [ -z $2 ]; then
      mysql $1
    elif [ -z $3 ]; then
      mysql -vvv $1 < $2
    else
      mysql -t -vvv $1 < $2 >> $3
    fi
  fi
}

function dumpme {
  nice mysqldump $1 > $2.dump.sql
  echo 'Done. Now zipping.'
  nice gzip $2.dump.sql
  echo 'Done.'
  ls -l $2.dump.sql.gz
}
# -------------------------------------------------------------------------

# MACHINE SPECIFIC
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
