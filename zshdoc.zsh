#!/usr/bin/env zsh

#####################################################################
# PROGRAM: zshdoc
# AUTHOR:  wlh4
# ORIGIN:  2021-02-02
# VERSION: v1.0 2021-02-02
# USAGE:   $ zshdoc ==> pick a type of zsh documentation
# COMMENTS:
# - this is designed to work with MacPorts version of zsh
# - change 'prefix' to work with your system
#####################################################################

prefix="/opt/local/share"

mantypes () {
    echo "\nPick a man type:"
    mantypedir="${prefix}/man/man1"
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
    2) info "${prefix}/info/zsh.info" ;;
    3) open "${prefix}/doc/zsh/pdf/zsh.pdf" ;;
    4) open "${prefix}/doc/zsh/html/index.html" ;;
    5) open "http://zsh.sourceforge.net" ;;
    6) open "http://zsh.sourceforge.net/Intro/intro_toc.html" ;;
    7) open "https://www.zsh.org" ;;
    8) open "https://doc.lagout.org/operating%20system%20/linux/Commands%20and%20Shell%20Programming/From%20Bash%20to%20Z%20Shell.pdf" ;;
    9) open "https://ohmyz.sh" ;;
  esac
}
