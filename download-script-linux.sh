#!/bin/bash
: '
Downloading and confiuring repo
'

function download() {

    # Checking if git is installed
    if command -v git >/dev/null 2>&1 ; 
    then
        echo -e  "Git is installed - skiping install\n"
        sudo apt install git -y
    else
        echo "Git is not installed - installing git\n"
        sudo apt install git -y
    fi

    # Function for setting up the repo
    sudo mkdir /pqc && cd /pqc && sudo git clone https://github.com/crt2626/pqc-eval-tools.git
    sudo chown -R $USER:$USER /pqc
    sudo chmod -R 755 /pqc

    cd /pqc/pqc-eval-tools/scripts
    chmod +x /pqc/pqc-eval-tools/*.sh

}

# Checking if the directory is already there
if [ -d "/pqc" ];
then 
    sudo rm -r /pqc
    download
else
    download
fi

echo -e "\nRepo has been setup in the /pqc directory\n"
