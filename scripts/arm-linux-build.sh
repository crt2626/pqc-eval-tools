#!/bin/bash

# Declaring direcotry path varibales
root_dir="/pqc/pqc-eval-tools"
build_dir="arm-liboqs-linux"

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

# Enabling ARM_PMU
if grep -q "Raspberry Pi" /proc/device-tree/model; then

    # Checking if the system is a Pi and installing kernel-headers
    if ! dpkg -s "raspberrypi-kernel-headers" >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install raspberrypi-kernel-headers
    fi

    #Enabling user access PMU
    cd "$root_dir"/dependency-libs/pqax/enable_ccr
    make
    make install 
    
fi

# Setting up directory and building liboqs
cd "$root_dir"/liboqs
mkdir arm-liboqs-linux
cd arm-liboqs-linux
cmake -GNinja OQS_SPEED_USE_ARM .. -DCMAKE_INSTALL_PREFIX=./
ninja -j 4
ninja install

# Making directory for this build and moving
cd ../
mv arm-liboqs-linux ../builds/