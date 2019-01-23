#!/bin/bash

filename="todos"
done_filename="todos_done"

int=[0-9]+$

if [ ! -e $filename ]; then
  touch $filename
fi

if [ ! -e $done_filename ]; then
  touch $done_filename
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
    cat $filename
    ;;
  -ld)
    cat $done_filename
    ;;
  -a | --add)
    line_count=`cat $filename | wc -l`
    echo $line_count
    echo "`expr $line_count + 1` $2" >> $filename
    ;;
  -d | --done)
    if [[ $2 =~ $int ]]; then
      grep "$2\s[.*]*" $filename > $done_filename && grep -v "$2\s[.*]*" $filename > "xyz.tmp" && mv "xyz.tmp" $filename
    else
      echo "$0: $2 is not integer."
    fi
    ;;
  -r | --remove)
    if [[ $2 =~ $int ]]; then
      echo "confirm (y/n) >> "
      read confirm
      if [ $confirm = "y" ]; then
        grep -v "$2\s[.*]*" $filename > "xyz.tmp" && mv "xyz.tmp" $filename
      fi
    else
      echo "$0: $2 is not integer."
    fi
    ;;
  --clean)
    > $filename
    ;;
  *)
    echo "kikoru: invalid option -- '$1'"
    echo "Try 'kikoru -h' for more information."
    ;;
esac