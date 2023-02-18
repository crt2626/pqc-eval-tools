#!/bin/bash
: '
Downloading and confiuring repo
'
# Working 
mkdir /pqc && cd /pqc && git clone https://github.com/crt2626/pqc-eval-tools.git
cd /pqc/pqc-eval-tools/scripts
chmod +x *.sh