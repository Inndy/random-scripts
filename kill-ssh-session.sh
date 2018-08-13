#!/bin/bash

current_tty() {
    tty | cut -b 10-
}

current_user_processes() {
    ps -ef | grep "^${USER}"
}

current_user_ssh_connections() {
    current_user_processes | grep "sshd: ${USER}@pts\/"
}

ps_pid() {
    awk '{print $2}'
}

TTY=$(current_tty)

current_user_ssh_connections | grep -v "${USER}@pts.${TTY}" | ps_pid | xargs kill -9