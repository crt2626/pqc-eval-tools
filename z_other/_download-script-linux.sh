#!/bin/bash
: '
Downloading and confiuring repo
'

function download() {

    # Function for setting up the repo
    sudo mkdir /pqc && cd /pqc && sudo git clone https://github.com/crt2626/pqc-eval-tools.git
    sudo chown -R $USER:$USER /pqc
    sudo chmod -R 755 /pqc

    cd /pqc/pqc-eval-tools/scripts
    chmod +x /pqc/pqc-eval-tools/*.sh

}

function dependency_install() {

    # Check for and install required packages
    packages=(astyle cmake gcc ninja-build libssl-dev python3-pytest python3-pytest-xdist unzip xsltproc doxygen graphviz python3-yaml valgrind)
    not_installed=()
    for package in "${packages[@]}"; do
        if ! dpkg -s "$package" >/dev/null 2>&1; then
            not_installed+=("$package")
        fi
    done
    if [[ ${#not_installed[@]} -ne 0 ]]; then
        sudo apt-get update
        sudo apt-get install "${not_installed[@]}"
    fi

}

# Checking if the directory is already there
if [ -d "/pqc" ];
then 
    sudo rm -r /pqc
    download
    dependency_install
else
    download
    dependency_install
fi

echo -e "\nRepo has been setup in the /pqc directory\n"