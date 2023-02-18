#!/bin/bash

: '
Performing setup of test suite
'
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