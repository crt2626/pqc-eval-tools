"""This python script will parse the results files outputed by the bash scripts so that be viewed in a easier format or further pasresed 
by python"""

"""Importing modules and declaring Global Variables"""
# Importing
import matplotlib as plt
import numpy as np
import pandas as pd
import re
import subprocess
import sys
import os

# Declaring gloabl
kem_algs = []
sig_algs = []
root_dir = "/pqc/pqc-eval-tools"



def get_algs():
    """Function for creating list of algorithms"""

    # Getting the kem algs
    with open("./alg-names/kem-algs-list.txt", "r") as kem_file:

        for line in kem_file:
            kem_algs.append(line)
    
    # Getting the digital siganture algorithms
    with open("./alg-names/sig-algs.txt", "r") as alg_file:

        for line in alg_file:
            sig_algs.append(line)


def speed_processing(speed_file):
    """Importing and processing result files"""
    # Declaring initial variables
    kem_prefix = "test-kem-speed-"
    sig_prefix = "test-sig-speed-"

    for type_count in range(1,4,1):
        'needs fixed '
        type_dir = "./csv-speed/type-" + str(type_count) + "/"
        og_dir = "./z_og-files/" + str(type_count) + "/"

        # Reading the original csv files and formating
        for file_count in range(1,16,1):

            # Formating KEM files
            filename_kem_pre = og_dir + kem_prefix + str(file_count) + ".csv"
            temp_df = pd.read_csv(filename_kem_pre, delimiter="|", index_col=False)
            temp_df = temp_df.drop(0)
            filename_kem = type_dir + kem_prefix + str(file_count) + ".csv"
            temp_df.to_csv(filename_kem, index=False)

            # Formating digital signature files
            filename_sig_pre = og_dir + sig_prefix + str(file_count) + ".csv"
            temp_df = pd.read_csv(filename_sig_pre, delimiter="|", index_col=False)
            temp_df = temp_df.drop(0)
            filename_sig = type_dir + sig_prefix + str(file_count) + ".csv"
            temp_df.to_csv(filename_sig, index=False)


fieldnames = ["maxBytes", "maxHeap", "extHeap", "maxStack"]

def get_peak(mem_file, peak_metrics):
    """Takes the current massif.out file and gets the peak memory metrics. 
        It comes from the run_mem.py script found in OQS Profiling Project
        https://github.com/open-quantum-safe/profiling"""

    # Parsing function from OQS Profile Project
    # Gets max memory metric from algorithm operation
    peak = -1
    with open(mem_file, "r") as lines:
        for line in lines: 
            if line.startswith(" Detailed snapshots: ["):
                match = re.search(r"(\d+) \(peak\).*", line)
                if match:
                    peak = int(match.group(1))
            if peak > 0:
                if line.startswith('{: >3d}'.format(peak)): # remove "," and print all numbers except first:
                    nl = line.replace(",", "")
                    peak_metrics.extend(nl.split()[1:])
                    # print(" ".join(res))
    print(peak_metrics)
    return peak_metrics


def memory_processing(peak_metrics):
    """Looping through all memory files and creating csv files"""

    # Assigning directory varibales



def mutiple_tests(num_machines):
    """This function parases the results for multiple machines and stores them as csv files"""

    # Declaring directory variables
    results_dir = root_dir + "/results"
    up_mem = root_dir + "/up-results/liboqs/mem-results/"
    up_speed = root_dir + ""
    liboqs_speed = results_dir + "/liboqs/speed-results/"






def determine_test_type(multiple_machines):
    """Getting a y/n response from the user if tests where conducted across multiple machines"""
    prompt_flag =0

    # Getting input from user and ensuring it is valid
    while prompt_flag == 0:

       response = input(prompt + " (y/n) ").strip().lower()

       if response in {"y", "yes", "Yes"}:
        prompt_flag = 1
        multiple_machines = True

       elif response in {"n", "no", "No"}:
        prompt_flag = 1
        multiple_machines = False

       else:
        print("Response must be y/n")

    return multiple_machines

# def get_machine_number (num_machines):
#     """If multiple of machines are being tested, get the total number of machines"""

#     prompt_flag = 0

#     # Getting input from user and ensuring that it is valid
#     while prompt_flag == 0:

#         response = input(prompt, "Please enter the number of machines testsed - ")

#         try:
#             num_machines = int(input(prompt))



def main():
    """Main function for parsing the test results"""

    # Determinig if the test was performed on multiple machines
    multiple_machines = None
    num_machines = 0
    multiple_machines = determine_test_type(multiple_machines)

    if multiple_machines:
        num_machines = get_machine_number(num_machines)

    #Parsing the results
    if multiple_machines:

        #Parsing for multiple machines
        multiple_machines(num_machines)

    else:
        # Parsing for a single machine
        single_machine()