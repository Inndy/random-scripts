#!/bin/bash

# tty_pipe=$(tty)
# echo "\$tty_pipe = $tty_pipe"

[ -z "$USER" ] && echo -ne "User: " && read USER
[ -z "$PASS" ] && echo -ne "Password: " && read -s PASS

function autoptt()
{
    sleep 1
    echo -ne "${USER}\r"
    sleep 1
    echo -ne "${PASS}\r"

    sleep 1
    echo -ne "\r"
    sleep 1
    echo -ne "\r"
    sleep 1
    echo -ne "\r"
    sleep 1
    echo -ne "\r"
    sleep 1
    echo -ne "\r"

    sleep 1
    echo -ne "q"
    sleep 1
    echo -ne "q"
    sleep 1
    echo -ne "q"
    sleep 1
    echo -ne "g"
    sleep 1
    echo -ne "y"

    sleep 1
    echo -ne "\r"
    sleep 1
    echo -ne "\r"
}

autoptt | nc ptt.cc 23 > /dev/null #> $tty_pipe