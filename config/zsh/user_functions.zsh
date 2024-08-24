#File: Contains functions I want available in my session
# This file is sourced in .zshrc


function enable(){
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <service to enable>, must exist in /etc/sv:"
        ls /etc/sv
        return 1
    fi

    if [[ -d "/etc/sv/$1" ]]; then
        if [[ -d "/var/service/$1" ]]; then
            echo "$1 is already linked to /var/service:\n"
            sleep 0.3
            echo "Try to start $1.."
            sudo sv start $1
            sleep 0.1
        else
            echo "Trying to enable service $1"
            sudo ln -s /etc/sv/"$1" /var/service/
            sleep 0.2
            echo "Service $1 was enabled, status:\n"
            sudo sv start $1
        fi
    else
        echo "$1 does not exist in /etc/sv:"
        ls /etc/sv
        return 1
    fi
}

function disable(){
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <service to disable>, must exist in /var/service:"
        ls /var/service
        return 1
    fi

    if [[ -d "/var/service/$1" ]]; then
        sudo sv stop $1
        sudo rm /var/service/$1
        echo "Service $1 was disabled."
    else
        echo "$1 does not exist in /var/service:"
        ls /var/service
        return 1
    fi
}

function status(){
    if [ $# -lt 1 ]; then
        sudo vsv status
    else
        sudo sv status $1
    fi
}

function restart(){
    if [ $# -lt 1 ]; then
        echo "Usage: $0 <service> at /var/service:"
        ls /var/service
        return 1
    fi

    if  [[ -d "/var/service/$1" ]]; then
        sudo sv restart $1
    else
        echo "$1 does not exist in /var service:"
        ls /var/service
        return 1
    fi
}


function clip(){
    local cmd
    if [[ $# -lt 1 ]]; then
        cmd=$(cb p -nc -np)
    else
        cmd=$(cb p$1 -nc -np)
    fi
    read "response?Exec $cmd? [y/n]:"

    if [[ $response == "y" ]]; then
        eval $cmd
    else
        echo "Aborted."
    fi 
}

function p(){
    if [[ $# -lt 1 ]]; then
        echo $(cb p -nc -np)
        return 0
    elif [[ $1 -eq "--help" ]]; then
        echo "Usage: p [number] => contents of clipboard" 
        return 1
    elif [[ "$1" =~ ^([0-9]+|_[0-9]+)$ && "${1#_}" -lt 128 ]]; then
        local board="p$1" 
        echo $(cb $board -nc -np)
        return 0
    else
        echo "Usage: p [number] => contents of clipboard" 
    fi
}

function y(){
    if [[ $# -lt 1 ]]; then
        echo "Usage: y [number] [yankable stuff]"
        return 1
    elif [[ "$1" =~ ^([0-9]+|_[0-9]+)$ && "${1#_}" -lt 128 ]]; then
        local copy="cp$1"
        shift
        cb $copy "$*" -np
        return 0
    else
        cb cp "$*" -np
        return 0
    fi
}
