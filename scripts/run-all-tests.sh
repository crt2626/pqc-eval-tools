#!/bin/bash
root_dir="/pqc/pqc-eval-tools"

: '
Performing setup of test suite
'
# Checking if the build directories already exist
if [ -d "/pqc/pqc-eval-tools/builds/x86-liboqs-linux" ] || [ -d "/pqc/pqc-eval-tools/builds/arm-liboqs-linux" ]; 
then
    echo -e "There is current build available - skipping build\n"
else
    if [ "$(uname -m)" = "x86_64" ] && [ "$(uname -s)" = "Linux" ]; 
    then
        # x86 Linux
        echo -e "x86-Linux Detected - creating relevant build\n"
        ./x86-linux-build.sh

    elif [ "$(uname -m)" = arm* ]; 
    then
        # ARM
        echo -e "ARM Linux Detected - creating relevant build\n"
        ./arm-linux-build.sh

    else
        # Unsupported system
        echo "Unsupported System Detected - Manual Build Required!\n"
        exit 1
    fi
fi


# Creating unparsed results directory and clearing old results if present
sudo rm -r "$root_dir"/up-results/
mkdir -p "$root_dir"/up-results/liboqs/speed-results
mkdir -p "$root_dir"/up-results/liboqs/mem-results/
mkdir -p "$root_dir"/up-results/liboqs/mem-results/kem-mem-metrics/ && mkdir -p "$root_dir"/up-results/liboqs/mem-results/sig-mem-metrics/

# configuring scripts
chmod +x *.sh

#****************************************************************
: '
Conducting liboqs benchmarking tests
'
cd "$root_dir"/scripts
# Memory tests
./liboqs-mem-test.sh