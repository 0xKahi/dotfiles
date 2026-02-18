#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../utils.sh"

file_check() {
    if [[ ! -f "$1" ]]; then
        error "config not found: $1"
        echo ""
        exit 1 
    fi
}

run_pacman() {
    local config="$1"
    file_check "$config" || return 1

    local packages=()
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" || "$line" == \#* ]] && continue
        packages+=("$line")
    done < "$config" 

    echo ""
    debug "installing pacman packages"
    # echo "sudo pacman -S --needed ${packages[@]}"
    sudo pacman -S --needed "${packages[@]}"
}

run_yay() {
    local config="$1"
    file_check "$config" || return 1

    local packages=()
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" || "$line" == \#* ]] && continue
        packages+=("$line")
    done < "$config" 
    
    echo ""
    debug "installing yay packages"
    # echo "yay -S --needed ${packages[@]}"
    yay -S --needed "${packages[@]}"
}

install_devtools() {
    logblock "info" "Installing dev tools..."
    run_pacman "$SCRIPT_DIR/config/devtools.pacman.conf"
    run_yay "$SCRIPT_DIR/config/devtools.yay.conf"
    logblock "success" "Dev tools installed."
}

install_applications() {
    logblock "info" "Installing applications..."
    run_pacman "$SCRIPT_DIR/config/applications.pacman.conf"
    run_yay "$SCRIPT_DIR/config/applications.yay.conf"
    logblock "success" "all applications installed."
}

install_interface() {
    logblock "info" "Installing interface packages"
    run_pacman "$SCRIPT_DIR/config/interface.pacman.conf"
    run_yay "$SCRIPT_DIR/config/interface.yay.conf"
    logblock "success" "all interface packages installed."
}

options=("Dev Tools" "Applications" "Interface" "Quit")

logblock "debug" "Linux Setup"

COLUMNS=1
select choice in "${options[@]}"; do
    case $choice in
        "Dev Tools")    install_devtools; break ;;
        "Applications") install_applications; break ;;
        "Interface")    install_interface; break;;
        "Quit")         info "Exiting."; break ;;
        *)              warning "Invalid option, try again."; break;;
    esac
    echo ""
done
