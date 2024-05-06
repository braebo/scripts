#!/bin/zsh

#? terminal color functions

# red
function r() {
    fmt "\033[31m$1\033[0m"
}

# green
function g() {
    fmt "\033[32m$1\033[0m"
}

# blue
function b() {
    fmt "\033[34m$1\033[0m"
}

# dim (grey)
function dim() {
    fmt "\033[2m$1\033[0m"
}

# bold
function bb() {
    fmt "\033[1m$1\033[0m"
}

# Internal function to format
function fmt() {
    if [ -t 1 ]; then
        printf "%b\n" "$1"
    else
        echo "$1"
    fi
}

function e() {
    echo "$1"
}
