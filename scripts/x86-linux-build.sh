#!/bin/bash

root_dir="/pqc/pqc-eval-tools"

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

# Setting up directory and building liboqs
mkdir "$root_dir"/liboqs/x86-liboqs-linux
cmake -GNinja "$root_dir"/liboqs/. -DCMAKE_INSTALL_PREFIX="$root_dir"/liboqs/x86-liboqs-linux/.
ninja -j 4
ninja install

#Making directory for this build and moving
mv "$root_dir"/liboqs/x86-liboqs-linux "$root_dir"/builds/.
