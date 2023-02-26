#!/bin/bash

function download() {

    # Function for setting up the repo
    sudo mkdir /pqc && cd /pqc
    git clone https://github.com/crt2626/pqc-eval-tools.git
    git clone https://github.com/crt2626/pqc-docker.git
    sudo chown -R $USER /pqc/
    sudo chmod -R 755 /pqc
    chmod +x /pqc/pqc-eval-tools/scripts/*.sh && chmod +x /pqc/pqc-eval-tools/result-processing/parsing-scripts/*.py
    
}

function dependency_install() {

    # Check for and install required packages
    packages=(astyle cmake gcc ninja-build libssl-dev python3-pytest python3-pytest-xdist unzip xsltproc doxygen graphviz python3-yaml valgrind python3-pip)
    not_installed=()
    for package in "${packages[@]}"; do
        if ! dpkg -s "$package" >/dev/null 2>&1; then
            not_installed+=("$package")
        fi
    done
    if [[ ${#not_installed[@]} -ne 0 ]]; then
        apt-get update
        apt-get install -y "${not_installed[@]}"
    fi

    # Installing needed python modules
    pip install pandas
    pip install matplotlib

}

# Checking if the directory is already there
if [ -d "/pqc/" ];
then 
    rm -r /pqc/
    download
    dependency_install
else
    download
    dependency_install
fi

echo -e "\nRepo has been setup in the /pqc directory\n"