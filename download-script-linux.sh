#!/bin/bash
: '
Downloading and confiuring repo
'
function download() {

    # Function for setting up the repo
    mkdir /pqc && cd /pqc && git clone https://github.com/crt2626/pqc-eval-tools.git
    cd /pqc/pqc-eval-tools/scripts
    chmod +x *.sh

}

# Checking if the directory is already there
if [ -d "/pqc" ];
then 
    sudo rm -r /pqc
    download
else
    download
fi

echo -e "\nRepo has been setup in the /pqc direcotry\n"