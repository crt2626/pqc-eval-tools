#!/bin/bash
: '
Performing setup of test suite
'
# Creating the direcotry 
mkdir /pqc
git clone https://github.com/crt2626/pqc-eval-tools.git

# configuring scripts
cd /pqc/
chmod +x *.sh

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
if [ -d "../up-results" ];
then 
    sudo rm -r ../up-results/* 
else
    mkdir -p ../up-results/liboqs/speed-results && mkdir -p ../up-results/liboqs/mem-results/
    mkdir ../up-results/liboqs/mem-results/kem-mem-metrics/ && ../up-results/liboqs/mem-results/kem-mem-metrics/
fi

# configuring scripts
chmod +x *.sh

#****************************************************************
: '
Conducting liboqs benchmarking tests
'

# Memory tests
./liboqs-mem-tests.sh