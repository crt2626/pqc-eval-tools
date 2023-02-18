#!/bin/bash
root_dir="/pqc/pqc-eval-tools"

: '
Performing setup of test suite
'
#Checking system type and building
if [ "$(uname -m)" = "x86_64" ] && [ "$(uname -s)" = "Linux" ]; 
then
    # x86 Linux
    echo
    ./x86-linux-build.sh

elif [ "$(uname -m)" = arm* ]; 
then
  # ARM
  ./arm-linux-build.sh

else
    #Unsuppoutred system
    echo "Unsupported architecture or operating system for this script"
    exit 1
fi

# Creating unparsed results directory and clearing old results if present
if [ -d "$root_dir/up-results" ];
then 
    sudo rm -r "$root_dir"/up-results/
else
    mkdir -p "$root_dir"/up-results/liboqs/speed-results
    mkdir -p "$root_dir"/up-results/liboqs/mem-results/
    mkdir -p "$root_dir"/up-results/liboqs/mem-results/kem-mem-metrics/ && mkdir -p "$root_dir"/up-results/liboqs/mem-results/sig-mem-metrics/
fi

# configuring scripts
chmod +x *.sh

#****************************************************************
: '
Conducting liboqs benchmarking tests
'

# Memory tests
./liboqs-mem-tests.sh