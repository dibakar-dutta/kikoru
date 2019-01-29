#!/bin/bash
# Title: Kikoru v0.1.0
# Description: A command-line tool to manage Todos
# Author: hirakJS

dir="$HOME/.kikoru"
filename="todos"
fullpath=$dir/$filename
done_filename="todos_done"
done_fullpath=$dir/$done_filename

int=[0-9]+$

pushd () {
  command pushd "$@" > /dev/null
}

popd () {
  command popd "$@" > /dev/null
}

if [ ! -d $dir ]; then
  mkdir $dir
fi

if [ ! -e $filename ]; then
  pushd $dir
  touch $filename
  popd
fi

if [ ! -e $done_filename ]; then
  pushd $dir
  touch $done_filename
  popd
fi

case $1 in
  -v | --version)
    echo "0.1.0"
    ;;
  -h | --help)
    echo "Usage: kikoru [options]..."
    echo "Options:"
    echo "  -v,  --version      Display this app version information."
    echo "  -h,  --help         Display this information."
    echo "  -l,  --list         Display the list of todos."
    echo "  -ld                 Display the list of todos which are done."
    echo "  -a,  --add          Add new todo."
    echo "  -d,  --done         Mark as done."
    # echo "  -ud, --undone       Mark as done."
    echo "  -r,  --remove       Remove a todo."
    echo "       --clean        Remove all todos."
    ;;
  -l | --list)
    cat $fullpath
    ;;
  -ld)
    cat $done_fullpath
    ;;
  -a | --add)
    line_count=`cat $fullpath | wc -l`
    echo "`expr $line_count + 1` $2" >> $fullpath
    ;;
  -d | --done)
    if [[ $2 =~ $int ]]; then
      grep "$2\s[.*]*" $fullpath > $done_fullpath && grep -v "$2\s[.*]*" $fullpath > "xyz.tmp" && mv "xyz.tmp" $fullpath
    else
      echo "$0: $2 is not integer."
    fi
    ;;
  -r | --remove)
    if [[ $2 =~ $int ]]; then
      echo "confirm (y/n) >> "
      read confirm
      if [ $confirm = "y" ]; then
        grep -v "$2\s[.*]*" $fullpath > "xyz.tmp" && mv "xyz.tmp" $fullpath
      fi
    else
      echo "$0: $2 is not integer."
    fi
    ;;
  --clean)
    > $fullpath
    ;;
  *)
    echo "kikoru: invalid option -- '$1'"
    echo "Try 'kikoru -h' for more information."
    ;;
esac
