#!/bin/bash

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

# Checking if ARM system is a Raspberry and if true checking if kernel headers are needed
if grep -q "Raspberry Pi" /proc/device-tree/model; then
    if ! dpkg -s "raspberrypi-kernel-headers" >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install raspberrypi-kernel-headers
    fi
fi

#enabling user acces to ARM PMU kernel header
cd ../pqax/enable_ccr
make
make install 

# Setting up directory and building liboqs
cd ../../liboqs
mkdir arm-liboqs-linux
cd arm-liboqs-linux
cmake -GNinja OQS_SPEED_USE_ARM .. -DCMAKE_INSTALL_PREFIX=./
ninja -j 4
ninja install

# Making directory for this build and moving
cd ../
mv arm-liboqs-linux ../builds/