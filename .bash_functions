#!/bin/bash

_init ()
{
    greeter
}
command_not_found_handle ()
{
    if [ -x /usr/lib/command-not-found ]; then
        /usr/lib/command-not-found -- "$1";
        return $?;
    else
        if [ -x /usr/share/command-not-found/command-not-found ]; then
            /usr/share/command-not-found/command-not-found -- "$1";
            return $?;
        else
            printf "%s: command not found\n" "$1" 1>&2;
            return 127;
        fi;
    fi
}
d ()
{
    echo compiling;
    dmd "$1" -J"$(pwd)";
    R=$?;
    echo -ne "run after keypress CTRL-C to cancel
----------------------------------------------\r";
    read -sn1;
    if [[ $R == 0 ]]; then
        echo -e "\n";
        clean;
        ./"$(echo "$1" | cut -d. -f1)";
    else
        echo fail;
    fi
}
from ()
{
    ARGS=$*;
    ARGS=$(python3 -c "import re; s = '$ARGS'.replace(',', ', '); args = ' '.join(re.findall(r'^([\d\w]+) import ([\d\w, ]+)$', s)[0]).split(' '); print('from', args[0], 'import', ' '.join(args[1:]).replace(',', '').replace(' ', ','))");
    echo -ne '\0x04' | python3 -i;
    python3 -c "$ARGS" &> /dev/null;
    if [[ $? != 0 ]]; then
        echo "junk module in list";
    else
        echo "$ARGS: success!";
    fi;
    python3 -i -c "$ARGS"
}

garbage ()
{
    for _ in `seq 1 128`;
    do
        UUID_TS=$(date +%s);
        NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1);
        echo -n "$NEW_UUID";
    done;
    echo
}
git_prompt ()
{
    git branch &> /dev/null && __git_ps1 ' (⎇ %s??!) '
}
greeter ()
{
    TRIM=`date +%H | tr -dc '0-9'`;
    HOUR=`python3 -c "print(__import__('re').match(r'[0]*([1-9]+)', __import__('sys').argv[1]).groups()[0])" $TRIM`;
    if [ ! "$HOUR" ] | (( "$HOUR" <= '11' )); then
        TOD='Morning';
    else
        if (("$HOUR" >= '12')) && (("$HOUR" <= '16')); then
            TOD='Afternoon';
        else
            if (("$HOUR" >= '17')) && (("$HOUR" <= '23')); then
                TOD='Evening';
            fi;
        fi;
    fi;
    fortune;
    echo;
    echo $TOD, Cat.;
    /usr/bin/mouse ~/projects/mouse/code/time-chap/time-chap-once.m02
}
import ()
{
    ARGS=$*;
    ARGS=$(python3 -c "import re;print(', '.join(re.findall(r'([\d\w]+)[, ]*', '$ARGS')))");
    echo -ne '\0x04' | python3 -i;
    python3 -c "import $ARGS" &> /dev/null;
    if [[ $? != 0 ]]; then
        echo "sorry, junk module in list";
    else
        echo "imported $ARGS";
    fi;
    python3 -i -c "import $ARGS"
}
jsls ()
{
    NAME=$(python3 -c 'print(__import__("sys").argv[1].split(".")[0])' "$1");
    lispy "$NAME.ls" || return 2;
    prepend js "$NAME.js" || return 2;
    echo "output file: $NAME.js"
}
mkrand ()
{
    mkuuid "$1" | tr -dc '0-9'
}
mkuuid ()
{
    if [ $# != 1 ]; then
        echo "Usage: mkuuid <length>";
    else
        if [ "py" == "$1" ]; then
            python3 ~/projects/py/UUID.py;
        else
            UUID_TS=$(date +%s);
            NEW_UUID="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1)";
            echo "$NEW_UUID";
        fi;
    fi
}
nonzero_return ()
{
    RETVAL=$?;
    [ $RETVAL -ne 0 ] && echo "$RETVAL | "
}
notify ()
{
    if [ "alrt" == "$1" ]; then
        notify-send --urgency=critical -t 5000 -i "$([ $? = 0 ] && echo terminal || echo error)" "hello";
    fi
}
prepend ()
{
    if [ $# != 2 ]; then
        echo "Usage: prepend <shebang> <file>";
        return;
    fi;
    case $1 in
        "p6")
            SHEB="#!/usr/bin/env perl6"
        ;;
        "py")
            SHEB="#!/usr/bin/env python3"
        ;;
        "py2")
            SHEB="#!/usr/bin/env python3"
        ;;
        "bash")
            SHEB="#!/usr/bin/env bash"
        ;;
        "sh")
            SHEB="#!/bin/sh"
        ;;
        "go")
            SHEB="package main

func main() {

}"
        ;;
        "c")
            SHEB="#include <stdio.h>

int main(int argc, const char *argv[]) {
  /* code here */
  return 0;
}"
        ;;
        "cpp")
            SHEB="#include <iostream>
void main() {
  /* shitty code */
}"
        ;;
        "pike")
            SHEB="#!/usr/bin/env pike
#ifndef __PIKE__
  #define array(string)argv char const *argv[]
#endif

int main(int argc, array(string)argv) {
  /* code here */
  return 0;
}"
        ;;
        "d")
            SHEB="module foobar;

import std.stdio;

void main(string[] args) {
  /* code here */
}"
        ;;
        "js")
            SHEB="#!/usr/bin/env js
var Assert = function () {
  \"use strict\";

  var AssertionError = function (msg) {
    var final = \"Assertion failed: \" + msg;
    console.error(final);
  };

  var args = arguments;
  var res  = true;

  for(var i = 0; i < args.length; i++) {
    var d   = ((i - 1) < 0) ? 0 : i - 1;
    res     = (args[i] === args[d]);
    if(!res || typeof res === \"undefined\" || res === null || res !== res) {
      throw new AssertionError(args[i] + \" != \" + args[d]);
    }
  }

  var atn = \"not_undefined\";

  try {
    atn = assert(res);
  } catch (e) {
    if(e instanceof ReferenceError) {
      return true;
    }
  }

  if(typeof atn === \"undefined\") {
    return true;
  }
};"
        ;;
        *)
            echo 'not a recognised shebang format :(';
            return
        ;;
    esac;
    uuid=$(mkuuid 6);
    ( echo "$SHEB";
    cat "$2" ) > "._$uuid";
    mv "._$uuid $2";
    chmod +x "$2"
}
rm ()
{
    echo -n "rm $*? (yes/no) ";
    read ip;
    if [[ $ip == "yes" ]]; then
        echo; /bin/rm -v "$@";
    fi
}
up ()
{
    echo;
    echo removing the lock...;
    sudo /bin/rm -rf /var/lib/apt/lists/lock;
    echo;
    if [ "$1" ]; then
        echo "updating package lists (this may take a while)...";
        echo;
        sudo apt update;
    fi;
    echo upgrading packages...;
    echo;
    sudo apt upgrade;
    echo "automatically removing unecessary packages (press CTRL-C to stop)...";
    sudo apt-get autoremove;
    echo;
    echo updating initramfs;
    sudo update-initramfs -u;
    echo updating grub;
    sudo update-grub;
    echo updating the menu...;
    sudo chmod -cR -x /usr/share/menu/*;
    sudo update-menus;
    echo updating locate-db;
    sudo updatedb
}
vl ()
{
    valgrind "$@"
}
