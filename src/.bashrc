wait_to_ssh()
{
  host=`echo ${1} | awk -F@ '{ print \$2 }'`
  while true
  do
  ping -c 1 ${host} > /dev/null && ssh ${1}
  sleep 1
  done
}

load_file_if_exists()
{
  if [ -f "$1" ]
  then
    source "$1"
  fi
}

remove_if_exists()
{
  if [ -e "$1" ]
  then
    rm -rf "$1"
  fi
}

set_1_to_2_unless_4_fails_then_3()
{
  foo=`${4}`
  if [ $? -eq 0 ]
  then
    eval "export ${1}=${2}"
  else
    eval "export ${1}=${3}"
  fi
}

remove_if_exists  $HISTFILE

bc="bash_completion"
if [[ `uname` = 'FreeBSD' ]]
then
  bc="/usr/local/etc/${bc}"
elif [[ `uname` = 'Linux' ]]
then
  bc="/etc/${bc}"
fi

load_file_if_exists $bc
load_file_if_exists /etc/profile


alias go='pushd'
alias b='popd'
alias h='history'
alias r='rm -r'
alias c='clear'
alias l='ls --color'
alias ll='ls -lA --color'
alias t='tail -n 50'
alias g='egrep --color'

pskill()
{
        local pid

        pid=$(ps -ax | grep $1 | grep -v grep | awk '{ print $1 }')
        echo -n "killing $1 (process $pid)..."
        kill -9 $pid
}

history_number()
{
  local num=`history | tail -n 1 | awk '{ printf "%3d", $1 + 1 }'`
  if [ -z $num ]; then
    num='  1'
  fi
  echo -n "${num}"
}

time_of_day()
{
  local t=`date +%R`
  echo -n "${t}"
}

present_working_directory()
{
  local d=`pwd | awk '{ printf "%-66s", $1 }'`
  echo -n "${d}"
}

full_prompt_data()
{
  echo "`present_working_directory` `time_of_day` `history_number`"
}

set_prompt()
{
  local tty=`tty | awk -F/ '{ print $3 $4}'`
  local   red="\[\e[01;31m\]"
  local normal="\[\e[00;0m\]"
  local p="${red}: `full_prompt_data` ;\n${normal} "
  local xterm_title="\[\e]0;${tty} \u@\H\007\]"
  if [ "${TERM}" = "xterm" ]
  then
    export  PS1="${xterm_title}${p}"
  else
    export  PS1="${p}"
  fi
  export  PS2=" "
  export  PS3=" "
}

umask 002

export  PROMPT_COMMAND='set_prompt'

set_1_to_2_unless_4_fails_then_3 "EDITOR" "vim" "vi" "which vim"

export  HISTIGNORE="&:h:exit"
export  RUBYOPT=rubygems
export  PATH=$PATH:/sbin/:/usr/sbin/:$HOME/bin:.
export  TZ=/usr/share/zoneinfo/America/Los_Angeles
