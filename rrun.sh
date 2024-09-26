#!/bin/bash

CONFIG_FILE="rrun.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file $CONFIG_FILE not found!"
    exit 1
fi

show_help() {
    echo "Usage: rrun [OPTIONS] <command>"
    echo
    echo "Run a command with privilege elevation."
    echo
    echo "Options:"
    echo "  -h, --help        Show this help message and exit"
    echo "  -v, --version     Show the version of rrun"
    echo "  -s, --superuser   Simulate running as root"
    echo
    echo "Example:"
    echo "  rrun ls /root"
    echo "  rrun -s ls /root"
}

show_version() {
    echo "rrun version 0.1 alpha"
}

if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

current_user=$(whoami)
command_to_run="$@"
is_superuser=false
allowed=false
nopass=false

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -h | --help )
    show_help
    exit 0
    ;;
  -v | --version )
    show_version
    exit 0
    ;;
  -s | --superuser )
    is_superuser=true
    shift
    ;;
esac; shift; done

check_permissions() {
    local config_line
    while IFS= read -r config_line || [[ -n "$config_line" ]]; do
        config_line=$(echo "$config_line" | sed 's/#.*//')  # Remove comments
        if [[ -z "$config_line" ]]; then continue; fi       # Skip empty lines

        # Parse the line for user permissions
        set -- $config_line
        if [[ $1 == "permit" ]]; then
            permitted_user=$2
            permitted_as_user=$4
            permitted_cmd=$6
            nopass_option=$7

            # Check if the current user has permission
            if [[ "$current_user" == "$permitted_user" ]] || [[ "$permitted_user" == ":wheel" ]]; then
                if [[ -z "$permitted_cmd" ]] || [[ "$command_to_run" == *"$permitted_cmd"* ]]; then
                    if [[ "$is_superuser" == true ]] && [[ "$permitted_as_user" == "root" ]]; then
                        allowed=true
                        if [[ "$nopass_option" == "nopass" ]]; then
                            nopass=true
                        fi
                        return
                    elif [[ "$is_superuser" == false ]]; then
                        allowed=true
                        return
                    fi
                fi
            fi
        fi
    done < "$CONFIG_FILE"
}

check_permissions

if [ "$allowed" != true ]; then
    echo "Error: $current_user is not permitted to run this command as root."
    exit 1
fi

if [ "$nopass" != true ]; then
    echo -n "[rrun] password for $current_user: "
    read -s entered_password
    echo

    password="password123"
    if [ "$entered_password" != "$password" ]; then
        echo "Sorry, try again."
        exit 1
    fi
else
    echo "Running command without password prompt (nopass)..."
fi

if [ "$is_superuser" == true ]; then
    echo "Running as root..."
fi

eval "$@"
