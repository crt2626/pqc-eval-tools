#!/bin/bash

# Initial Setup
cd ../builds/x86-liboqs-linux/tests
pwd
echo -e "Performing Directory Clearing and Structuring:-\n"

: '
Setting up directories and creating variables and arrays
'
#Creating directories and clearing previous results

# Creating memory directory
if [ -d ../mem-results ];
then
    sudo rm ../mem-results/*
else
    mkdir ../mem-results
fi

#Clearing previous speed results
sudo rm ../results/*

# Declaring memory variables and alg arrays
kem_algs=(
  "BIKE-L1"
  "BIKE-L3"
  "BIKE-L5"
  "Classic-McEliece-348864"
  "Classic-McEliece-348864f"
  "Classic-McEliece-460896"
  "Classic-McEliece-460896f"
  "Classic-McEliece-6688128"
  "Classic-McEliece-6688128f"
  "Classic-McEliece-6960119"
  "Classic-McEliece-6960119f"
  "Classic-McEliece-8192128"
  "Classic-McEliece-8192128f"
  "HQC-128"
  "HQC-192"
  "HQC-256"
  "Kyber512"
  "Kyber768"
  "Kyber1024"
  "Kyber512-90s"
  "Kyber768-90s"
  "Kyber1024-90s"
  "sntrup761"
  "FrodoKEM-640-AES"
  "FrodoKEM-640-SHAKE"
  "FrodoKEM-976-AES"
  "FrodoKEM-976-SHAKE"
  "FrodoKEM-1344-AES"
  "FrodoKEM-1344-SHAKE"
)

sig_algs=(
  "Dilithium2"
  "Dilithium3"
  "Dilithium5"
  "Dilithium2-AES"
  "Dilithium3-AES"
  "Dilithium5-AES"
  "Falcon-512"
  "Falcon-1024"
  "SPHINCS+-Haraka-128f-robust"
  "SPHINCS+-Haraka-128f-simple"
  "SPHINCS+-Haraka-128s-robust"
  "SPHINCS+-Haraka-128s-simple"
  "SPHINCS+-Haraka-192f-robust"
  "SPHINCS+-Haraka-192f-simple"
  "SPHINCS+-Haraka-192s-robust"
  "SPHINCS+-Haraka-192s-simple"
  "SPHINCS+-Haraka-256f-robust"
  "SPHINCS+-Haraka-256f-simple"
  "SPHINCS+-Haraka-256s-robust"
  "SPHINCS+-Haraka-256s-simple"
  "SPHINCS+-SHA256-128f-robust"
  "SPHINCS+-SHA256-128f-simple"
  "SPHINCS+-SHA256-128s-robust"
  "SPHINCS+-SHA256-128s-simple"
  "SPHINCS+-SHA256-192f-robust"
  "SPHINCS+-SHA256-192f-simple"
  "SPHINCS+-SHA256-192s-robust"
  "SPHINCS+-SHA256-192s-simple"
  "SPHINCS+-SHA256-256f-robust"
)

kem_mem_prefix="../results/mem-results/kem-mem-metrics-"
sig_mem_prefix="../results/mem-results/sig-mem-metrics-"
mem_metrics_headers="Algorithm, Operation, Heap (bytes), Stack (bytes), Total (bytes)"

# Operation arrays
op_kem=("Keygen" "Encaps" "Decaps")
op_sig=("Keygen" "Sign" "Verify")

#*************************************************************************
: '
Performing memory tests
'
echo -e "***************************\n"
echo -e "Performing Memory Tests:-\n"
echo -e "***************************\n\n"

# Performing the memorry tests 15 times each
for run_count in {1..15}
do
    echo -e "Memory Test Run - $run_count\n\n"
    
    # Creating filenames and outputing headers
    kem_filename="$kem_mem_prefix-$run_count.csv"
    sig_filename="$sig_mem_prefix-$run_count.csv"
    echo $mem_metrics_headers > "$kem_filename"
    echo $mem_metrics_headers > "$sig_filename"

    echo -e "KEM Memory Tests\n"
    # KEM memory tests
    for kem_alg in "${kem_algs[@]}"
    do
        # Testing memory metrics for each operation
        for operation_1 in {0..2}
        do
            # Getting operation string
            op_kem_str=${op_kem[operation_1]}

            # Running valgrind and getting the required metrics
            valgrind --tool=massif --massif-out-file=massif.out ./test_kem_mem "$kem_alg" "$operation_1"
            heap_bytes=$(ms_print massif.out | grep -oP "heap=([0-9]+)" | grep -oP "([0-9]+)")
            stack_bytes=$(ms_print massif.out | grep -oP "stack=([0-9]+)" | grep -oP "([0-9]+)")
            total_bytes=$(ms_print massif.out | grep -oP "mem_heap_B=[0-9]+" | grep -oP "[0-9]+")
            rm massif.out

            # Outputing metric information to csv file
            echo "$kem_alg, $op_kem_str, $heap_bytes, $stack_bytes, $total_bytes" >> "$kem_filename"

        done

    done

    echo -e "\nDigital Signature Memory Tests\n"
    # Digital signature memory tests
    for sig_alg in "${sig_algs[@]}"
    do
        # Testing memory metrics for each operation
        for operation_2 in {0..2}
        do
            # Getting operation string
            op_sig_str=${op_sig[operation_2]}

            # Running valgrind and getting the required metrics
            valgrind --tool=massif --massif-out-file=massif.out ./test_sig_mem "$sig_alg" "$operation_2"
            heap_bytes=$(ms_print massif.out | grep -oP "heap=([0-9]+)" | grep -oP "([0-9]+)")
            stack_bytes=$(ms_print massif.out | grep -oP "stack=([0-9]+)" | grep -oP "([0-9]+)")
            total_bytes=$(ms_print massif.out | grep -oP "mem_heap_B=[0-9]+" | grep -oP "[0-9]+")
            rm massif.out

            # Outputing metric information to csv file
            echo "$sig_alg, $op_sig_str, $heap_bytes, $stack_bytes, $total_bytes" >> "$sig_filename"

        done

    done

done

echo -e "\nMemory Tests Comeplete\n"
#************************************************************************************************

# Doing Speed tests
#./full-alg-speed 