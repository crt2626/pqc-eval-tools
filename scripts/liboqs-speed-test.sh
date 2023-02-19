#!/bin/bash

# Declaring direcotry path variables
root_dir="/pqc/pqc-eval-tools"

#****************************************************************
: '
Peforming liboqs CPU speed benchmarking tests
'
# Getting build directory
if [ -d "$root_dir/builds/x86-liboqs-linux" ]; 
then
    # Moving direcotory and clearing old results
    build_dir="builds/x86-liboqs-linux" 
    cd "$root_dir"/"$build_dir"/results && rm *
    cd "$root_dir"/"$build_dir"/tests

elif [ -d "$root_dir/builds/arm-linux-build.sh" ];
then
    # Moving direcotory and clearing old results
    build_dir="builds/arm-linux-build"
    cd "$root_dir"/"$build_dir"/results && rm *
    cd "$root_dir"/"$build_dir"/tests

else
    echo -e "No Build Directory Deteced - Please Build Liboqs to proceed\n"
    exit 1
fi

# Performing both KEM and Digital Signature test
cd "$root_dir"/"$build_dir"/tests
./full-alg-speed

# Moving results
mv "$root_dir"/"$build_dir"/results "$root_dir"/up-results/liboqs/speed-results/
mkdir -p "$root_dir"/"$build_dir"/results
cd "$root_dir"/scripts
#****************************************************************
