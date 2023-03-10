#!/bin/bash

function download() {

    # Function for setting up the repo
    cd /pqc
    git clone https://github.com/crt2626/pqc-eval-tools.git
    git clone https://github.com/crt2626/pqc-docker.git
    sudo chown -R $USER /pqc/ && sudo chmod -R 755 /pqc
    chmod +x /pqc/pqc-eval-tools/scripts/*.sh && chmod +x /pqc/pqc-eval-tools/result-processing/parsing-scripts/*.py
    mkdir -p /pqc/output && mkdir -p /pqc/output/op1 && mkdir -p /pqc/output/op2 && mkdir -p /pqc/output/op3
    echo "0" > /pqc/pqc-eval-tools/backup.flag

    # Clearing up-results that were pulled from repo 
    cd /pqc && sudo rm -r up-results
    mkdir up-results
     
}

function dependency_install() {

    # Check for and install required packages
    packages=(git astyle cmake gcc ninja-build libssl-dev python3-pytest python3-pytest-xdist unzip xsltproc doxygen graphviz python3-yaml valgrind python3-pip rsync smbclient cifs-utils)
    not_installed=()
    for package in "${packages[@]}"; do
        if ! dpkg -s "$package" >/dev/null 2>&1; then
            not_installed+=("$package")
        fi
    done
    if [[ ${#not_installed[@]} -ne 0 ]]; then
        sudo apt-get update
        sudo apt-get install -y "${not_installed[@]}"
    fi

    # Installing needed python modules
    pip install pandas
    pip install matplotlib

}

# Checking if the directory is already there
if [ -d "/pqc/" ];
then 
    cd /pqc
    sudo rm -r pqc-docker && sudo rm -r pqc-eval-tools
    download
    dependency_install
else
    sudo mkdir /pqc && cd /pqc
    sudo chown -R $USER /pqc && sudo chmod -R 755 /pqc
    download
    dependency_install
fi

# Setting backup flag
echo "0" > /pqc/pqc-eval-tools/backup.flag

echo -e "\nRepo has been setup in the /pqc directory\n"