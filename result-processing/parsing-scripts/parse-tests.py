"""This python script will parse the results files outputed by the bash scripts so that be viewed in a easier format or further pasresed 
by python"""

"""Importing modules and declaring Global Variables"""
# Importing
import pandas as pd
import re
import os
import shutil

# Declaring gloabl
kem_algs = []
sig_algs = []
root_dir = "/pqc/pqc-eval-tools/"


#***********************************************************************
def get_algs():
    """Function for creating list of algorithms"""

    # Setting alg text file directories
    kem_algs_file = root_dir + "result-processing/algs/kem-algs-list.txt"
    sig_algs_file = root_dir + "result-processing/algs/sig-algs-list.txt"

    # Getting the kem algs
    with open(kem_algs_file, "r") as kem_file:

        for line in kem_file:
            line = line.strip()
            kem_algs.append(line)
    
    # Getting the digital siganture algorithms
    with open(sig_algs_file, "r") as alg_file:

        for line in alg_file:
            line = line.strip()
            sig_algs.append(line)


#***********************************************************************
def speed_processing(type_speed_dir, up_speed_dir):
    """Importing and processing result files"""

    # Declaring initial variables
    kem_prefix = "test-kem-speed-"
    sig_prefix = "test-sig-speed-"


    # Reading the original csv files and formating
    for file_count in range(1,16,1):

        # Formating KEM files
        filename_kem_pre = up_speed_dir + kem_prefix + str(file_count) + ".csv"
        temp_df = pd.read_csv(filename_kem_pre, delimiter="|", index_col=False)
        temp_df = temp_df.drop(0)
        filename_kem = type_speed_dir + kem_prefix + str(file_count) + ".csv"
        temp_df.to_csv(filename_kem, index=False)

        # Formating digital signature files
        filename_sig_pre = up_speed_dir + sig_prefix + str(file_count) + ".csv"
        temp_df = pd.read_csv(filename_sig_pre, delimiter="|", index_col=False)
        temp_df = temp_df.drop(0)
        filename_sig = type_speed_dir + sig_prefix + str(file_count) + ".csv"
        temp_df.to_csv(filename_sig, index=False)


#***********************************************************************
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

    return peak_metrics


#***********************************************************************
def memory_processing(type_mem_dir, up_mem_dir):
    """Looping through all memory files and creating csv files"""

    # Assigning directory varibales
    kem_dir = up_mem_dir + "kem-mem-metrics/"
    sig_dir = up_mem_dir + "sig-mem-metrics/"
    kem_file_prefix = "kem-mem-metrics"
    sig_file_prefix = "sig-mem-metrics"
    new_row = []
    peak_metrics = []

    # file placeholders
    filednames = ["Algorithm", "Operation", "intits", "maxBytes", "maxHeap", "extHeap", "maxStack"]
    kem_operations = ["Keygen", "Encaps", "Decaps"]
    sig_operations = ["Keygen", "Sign", "Verify"]

    # Looping through each run count
    for run_count in range(1,16,1):

        # Creating temp dataframe
        temp_df = pd.DataFrame(columns=filednames)
        #Looping throuhg kem algorithms
        for kem_alg in kem_algs:

            kem_up_filename_pre = kem_dir + kem_file_prefix

            #Looping the operations and adding to temp dataframe 
            for operation in range(0,3,1):

                # Parsing metrics and adding results to dataframe row
                kem_up_filename = kem_up_filename_pre + "-" + kem_alg + "-" + str(operation) + "-" + str(run_count) + ".txt"
                peak_metrics = get_peak(kem_up_filename, peak_metrics)
                new_row.extend([kem_alg, kem_operations[operation]])
                new_row.extend(peak_metrics)
                temp_df.loc[len(temp_df)] = new_row

                # Clearing lists
                peak_metrics.clear()
                new_row.clear()

        # Outputing kem csv file for this run
        kem_filename = type_mem_dir + "kem-mem-metrics-" + str(run_count) + ".csv"
        temp_df.to_csv(kem_filename, index=False)


        #Looping throuhg kem algorithms
        for sig_alg in sig_algs:

            sig_up_filename_pre = sig_dir + sig_file_prefix

            #Looping the operations and adding to temp dataframe 
            for operation in range(0,3,1):

                # Parsing metrics and adding results to dataframe row
                sig_up_filename = sig_up_filename_pre + "-" + sig_alg + "-" + str(operation) + "-" + str(run_count) + ".txt"
                peak_metrics = get_peak(sig_up_filename, peak_metrics)   
                new_row.extend((sig_alg, sig_operations[operation]))
                new_row.extend(peak_metrics)
                temp_df.loc[len(temp_df)] = new_row

                # Clearing lists
                peak_metrics.clear()
                new_row.clear()

        # Outputing digital signature csv file for this run
        sig_filename = type_mem_dir + "sig-mem-metrics-" + str(run_count) + ".csv"
        temp_df.to_csv(sig_filename, index=False)


#***********************************************************************
def process_tests(num_machines):
    """This function parases the results for multiple machines and stores them as csv files"""

    # Declaring directory variables
    results_dir = root_dir + "results/"
    mem_dir = results_dir + "liboqs/" + "mem-results/"
    speed_dir = results_dir + "liboqs/" + "speed-results/"
    up_mem = root_dir + "up-results/liboqs/mem-results/"
    up_speed = root_dir + "up-results/liboqs/speed-results/"
    num_mach_range = num_machines + 1

    # Creating directory structure and remvoing previous results
    try: 

        # Making results direcotry structure
        os.makedirs(mem_dir)
        os.makedirs(speed_dir)
    
    except:

        # Removing the previous results
        shutil.rmtree(mem_dir)
        shutil.rmtree(speed_dir)
        os.makedirs(mem_dir)
        os.makedirs(speed_dir)


    for machine_num in range(1, num_mach_range, 1):

        type_name = "machine-" + str(machine_num) + "/"

        # Setting up directory path
        up_speed_dir = up_speed + type_name
        up_mem_dir = up_mem + type_name

        # Creating specifc result directories and clearing old results
        try: 
            
            # Speed result directories
            type_speed_dir = speed_dir + type_name
            os.makedirs(type_speed_dir)

            # Mem result directories
            type_mem_dir = mem_dir + type_name
            os.makedirs(type_mem_dir)

        except:

            # Setting the directory variables
            type_speed_dir = speed_dir + type_name
            type_mem_dir = mem_dir + type_name

            #Clearing the old results and making directories
            shutil.rmtree(type_speed_dir)
            shutil.rmtree(type_mem_dir)
            os.makedirs(type_speed_dir)
            os.makedirs(type_mem_dir)

        # Parsing results
        speed_processing(type_speed_dir, up_speed_dir)
        memory_processing(type_mem_dir, up_mem_dir)


#***********************************************************************  
def main():
    """Main function for parsing the test results"""

    # Print script description
    print(f"\n****************************************************************************************************************")
    print(f"This script will parse the results produced from the automatic tests and create CSV files for data analytics.")
    print(f"If tests have been carried out across multiple machines, please ensure all unparsed results are present.")
    print(f"****************************************************************************************************************\n\n")

    # Creating the algorithms list
    get_algs()

    # Getting the number of machines tested
    prompt_flag = 0
    
    while prompt_flag == 0:
        try:
            machine_num = int(input("Enter the number of machines tested - "))
            prompt_flag = 1
        except ValueError:
            print("Invlaid Input - Please enter a number! - ")

    # Processing the results
    print("Parsing results... ")
    process_tests(machine_num)
    print(f"\nResults have been processed - CSV files can be found in the Results Directory\n")


#***********************************************************************
"""Main boiler plate"""
if __name__ == "__main__":
    main()
