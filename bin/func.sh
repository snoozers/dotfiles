#!/bin/bash

export PLATFORM_OS
export DOT_PATH="$HOME/dotfiles"

is_exists() {
    which "$1" >/dev/null 2>&1
    return $?
}

e_error() {
    printf " \033[31m%s\033[m\n" "✖ $*" 1>&2
}

e_warning() {
    printf " \033[31m%s\033[m\n" "✖ $*"
}

e_done() {
    printf " \033[37;1m%s\033[m...\033[32mOK\033[m\n" "✔ $*"
}

e_success() {
    printf " \033[37;1m%s\033[m%s...\033[32mOK\033[m\n" "✔ " "$*"
}

ink() {
    if [ "$#" -eq 0 -o "$#" -gt 2 ]; then
        echo "Usage: ink <color> <text>"
        echo "Colors:"
        echo "  black, white, red, green, yellow, blue, purple, cyan, gray"
        return 1
    fi

    local open="\033["
    local close="${open}0m"
    local black="0;30m"
    local red="1;31m"
    local green="1;32m"
    local yellow="1;33m"
    local blue="1;34m"
    local purple="1;35m"
    local cyan="1;36m"
    local gray="0;37m"
    local white="$close"

    local text="$1"
    local color="$close"

    if [ "$#" -eq 2 ]; then
        text="$2"
        case "$1" in
            black | red | green | yellow | blue | purple | cyan | gray | white)
            eval color="\$$1"
            ;;
        esac
    fi

    printf "${open}${color}${text}${close}"
}

logging() {
    if [ "$#" -eq 0 -o "$#" -gt 2 ]; then
        echo "Usage: ink <fmt> <msg>"
        echo "Formatting Options:"
        echo "  TITLE, ERROR, WARN, INFO, SUCCESS"
        return 1
    fi

    local color=
    local text="$2"

    case "$1" in
        TITLE)
            color=yellow
            ;;
        ERROR | WARN)
            color=red
            ;;
        INFO)
            color=blue
            ;;
        SUCCESS)
            color=green
            ;;
        *)
            text="$1"
    esac

    timestamp() {
        ink gray "["
        ink purple "$(date +%H:%M:%S)"
        ink gray "] "
    }

    timestamp; ink "$color" "$text"; echo
}

log_pass() {
    logging SUCCESS "$1"
}

log_fail() {
    logging ERROR "$1" 1>&2
}

log_warn() {
    logging WARN "$1"
}

log_info() {
    logging INFO "$1"
}

log_echo() {
    logging TITLE "$1"
}

e_process_waiting() {
    printf "\r%${#$(log_echo $1...)}s" "$(log_echo $1...)"
}

e_process_done() {
    printf "\r%-${#$(log_echo "$1...")}s\n" "$(log_pass "$(e_success "$1")")"
}

e_process_fail() {
    printf "\r%-${#$(log_echo "$1...")}s\n" "$(log_warn "$(e_warning "$1")")"
}

die() {
    e_error "$1" 1>&2
    exit "${2:-1}"
}

has() {
    is_exists "$@"
}

os_detect() {
    export PLATFORM_OS
    case "$(uname)" in
        *'Linux'*) PLATFORM_OS='linux' ;;
        'Darwin')  PLATFORM_OS='osx' ;;
        *)         PLATFORM_OS='unknown' ;;
    esac
}

is_osx() {
    os_detect
    if [ "$PLATFORM_OS" = "osx" ]; then
        return 0
    else
        return 1
    fi
}

is_linux() {
    os_detect
    if [ "$PLATFORM_OS" = "linux" ]; then
        return 0
    else
        return 1
    fi
}

logo() {
    bash $DOT_PATH/bin/logo.sh
}
