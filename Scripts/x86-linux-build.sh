#!/bin/bash
#Setting up directory and building liboqs
cd ../liboqs
mkdir x86-liboqs-linux
cd x86-liboqs-linux
cmake -GNinja .. -DCMAKE_INSTALL_PREFIX=./
ninja -j 4
ninja install

#Moving build direcotry 
cd ../
mv x86-liboqs-linux ../Builds
