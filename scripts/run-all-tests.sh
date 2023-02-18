#!/bin/bash
: '
Performing setup of test suite
'
# configuring scripts
chmod +x *.sh

#Checking system type and building
if [ "$(uname -m)" = "x86_64" ] && [ "$(uname -s)" = "Linux" ]; 
then
    # x86 Linux
    ./x86-linux-build.sh

elif [ "$(uname -m)" = "armv7l" ]; 
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
done

# configuring scripts
chmod +x *.sh

#****************************************************************
: '
Conducting liboqs benchmarking tests
'

# Memory tests
./liboqs-mem-tests.sh