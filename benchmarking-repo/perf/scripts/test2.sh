#!/bin/bash


valgrind --tool=massif --stacks=yes --massif-out-file=./massif.out /opt/oqssa/bin/test_kem_mem BIKE-L1 0

ms_print massif.out