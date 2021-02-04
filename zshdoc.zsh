#!/usr/bin/env zsh

#####################################################################
# PROGRAM: zshdoc
# AUTHOR:  wlh4
# ORIGIN:  2021-02-02
# VERSION: v1.1 2021-02-03; added some error checking and prefix
#	   building
# USAGE:   $ zshdoc ==> pick a type of zsh documentation
#          $ zshdoc.zsh lns ==> add symbolic link to $DEV/bin
# COMMENTS:
# - This is designed to work with MacPorts version of zsh.
# - Change 'PREFIX' to work with your system
# - Change 'BIN' to the executable directory of your choice
#####################################################################

PREFIX="/opt/local/share"
PREFIX_OLD="/usr/share"
BIN=$DEV/bin

#####################################################################
# ERROR CHECKING

[[ $1 == "lns" ]] && {
    ln -vfs $PWD/zshdoc.zsh ${BIN}/zshdoc
}

[[ -d "${PREFIX}" ]] || {
    echo "'${PREFIX}' does not exist."
    echo "Changing to old prefix: ${PREFIX_OLD}"
    PREFIX="${PREFIX_OLD}"
}
[[ -d "${PREFIX}/zsh" ]] || {
   echo "'${PREFIX}/zsh' does not exist."
   exit 1
}
which zsh || exit 1 2> /dev/null

[[ -f ${BIN}/zshdoc ]] || {
    echo "'zshdoc' does not exist in ${BIN}"
    echo "Execute the command 'ln -s $PWD/zshdoc.zsh ${BIN}/zshdoc'"
    echo "Easier is: 'ln -s \$PWD/zshdoc.zsh \$DEV/bin/zshdoc'"
    echo "Even easier is './zshdoc.zsh lns'"
}
#####################################################################
# FUNCTIONS

mantypes () {
    echo "\nPick a man type:"
    mantypedir="${PREFIX}/man/man1"
    local n=0
    for mantype in $(ls -1 $mantypedir/zsh*)
    do
	let $((n++))
	zshtype=$(basename -s ".1.gz" $mantype)
	printf "%02d) %s\n" $n $zshtype
	z[$n]=$mantype
    done
    read -sk 2
    [[ $REPLY -lt 1 || $REPLY -gt 17 ]] && echo "$REPLY is out of range" || {
      man $z[${REPLY}]
    }
}

zshtypes () {
    echo "\nAvailable versions:"
    for type in $(where zsh)
    do
	printf "%20s---%s\n" "$type" "$($type --version)"
    done
}
#####################################################################
# CODE

echo "Choose one:"
n=0
for doc in version man-types info pdf html Z-Shell Intro zsh.org Book oh-my-zsh
do
  echo "$n) $doc"
  let $((n++))
done
read -sk
[[ $REPLY -lt 0 || $REPLY -gt 9 ]] && echo "$REPLY is out of range" || {
  case $REPLY in
    0) zshtypes ;;
    1) mantypes ;;
    2) info "${PREFIX}/info/zsh.info" ;;
    3) open "${PREFIX}/doc/zsh/pdf/zsh.pdf" ;;
    4) open "${PREFIX}/doc/zsh/html/index.html" ;;
    5) open "http://zsh.sourceforge.net" ;;
    6) open "http://zsh.sourceforge.net/Intro/intro_toc.html" ;;
    7) open "https://www.zsh.org" ;;
    8) open "https://doc.lagout.org/operating%20system%20/linux/Commands%20and%20Shell%20Programming/From%20Bash%20to%20Z%20Shell.pdf" ;;
    9) open "https://ohmyz.sh" ;;
  esac
}
#####################################################################
