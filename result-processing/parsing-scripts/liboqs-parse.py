"""This python script will parse the results files outputed by the bash scripts so that be viewed in a easier format or further pasresed 
by python"""

"""Importing modules and declaring Global Variables"""
import pandas as pd
import re
import os
import shutil
import sys
from avg_gen import gen_averages

# Declaring gloabl
kem_operations = ["keygen", "encaps", "decaps"]
sig_operations = ["keypair", "sign", "verify"]
kem_algs = []
sig_algs = []
system_type = ""
root_dir = ""

#***********************************************************************
def get_system_type() :
    """Function for checking the system type and setting root_dir path"""
    global root_dir, system_type

    # Checking and storing system type
    if sys.platform == "win32":

        system_type = "win"
        root_dir = r"..\.."

    else:
        system_type = "linux"
        root_dir = "/pqc/pqc-eval-tools"

    
#***********************************************************************
def get_algs():
    """Function for creating list of algorithms"""

    # Setting alg text file directories
    kem_algs_file = os.path.join(root_dir, "result-processing", "algs", "kem-algs-list.txt")
    sig_algs_file = os.path.join(root_dir, "result-processing", "algs", "sig-algs-list.txt")

    # # Getting the kem algs
    with open(kem_algs_file, "r") as kem_file:

        for line in kem_file:
            kem_algs.append(line.strip())
    
    # Getting the digital siganture algorithms
    with open(sig_algs_file, "r") as alg_file:

        for line in alg_file:
            sig_algs.append(line.strip())


#***********************************************************************
def speed_processing(type_speed_dir, up_speed_dir):
    """Importing and processing result files"""

    # Declaring initial variables
    kem_prefix = "test-kem-speed-"
    sig_prefix = "test-sig-speed-"

    # Creating algorithm list to insert into new column
    new_col_kem = [alg for alg in kem_algs for i in range(3)]
    new_col_sig = [alg for alg in sig_algs for i in range(3)]
    
        
    # Reading the original csv files and formating
    for file_count in range(1,16,1):

        """Formating Kem Files"""
        # Loading kem file into dataframe
        filename_kem_pre = kem_prefix + str(file_count) + ".csv"
        filename_kem_pre = os.path.join(up_speed_dir, filename_kem_pre)
        temp_df = pd.read_csv(filename_kem_pre, delimiter="|", index_col=False)

        # Striping trailing spaces and removing algorithms from Operation
        temp_df.columns = [col.strip() for col in temp_df.columns]
        temp_df = temp_df.loc[~temp_df['Operation'].str.strip().isin(kem_algs)]
        temp_df = temp_df.applymap(lambda val: val.strip() if isinstance(val, str) else val)

        # Inserting new algorithm column and outputing formated csv
        temp_df.insert(0, "Algorithm", new_col_kem)
        filename_kem = kem_prefix + str(file_count) + ".csv"
        filename_kem = os.path.join(type_speed_dir, filename_kem)
        temp_df.to_csv(filename_kem, index=False)

        """Formating Digital Signature Files"""
        # Loading kem file into dataframe and stiping trailing space in columns headers
        filename_sig_pre = sig_prefix + str(file_count) + ".csv"
        filename_sig_pre = os.path.join(up_speed_dir, filename_sig_pre)
        temp_df = pd.read_csv(filename_sig_pre, delimiter="|", index_col=False)

        # Striping trailing spaces and removing algorithms from Operation
        temp_df.columns = [col.strip() for col in temp_df.columns]
        temp_df = temp_df.loc[~temp_df['Operation'].str.strip().isin(sig_algs)]
        temp_df = temp_df.applymap(lambda val: val.strip() if isinstance(val, str) else val)

        # Inserting new column and outputting formated csv
        temp_df.insert(0, 'Algorithm', new_col_sig)
        filename_sig = sig_prefix + str(file_count) + ".csv"
        filename_sig = os.path.join(type_speed_dir, filename_sig)
        temp_df.to_csv(filename_sig, index=False)


#***********************************************************************
def get_peak(mem_file, peak_metrics):
    """Takes the current massif.out file and gets the peak memory metrics. 
        It comes from the run_mem.py script found in OQS Profiling Project
        https://github.com/open-quantum-safe/profiling"""

    # Parsing function from OQS Profile Project
    # Gets max memory metric from algorithm operation
    with open(mem_file, "r") as lines:
        peak = -1
        for line in lines:
            if line.startswith(" Detailed snapshots: ["):
                match=re.search("\d+ \(peak\).*", line)
                if match:
                    peak = int(match.group(0).split()[0])
       
            if (peak > 0):
                
                if line.startswith('{: >3d}'.format(peak)): # remove "," and print all numbers except first:
                    nl = line.replace(",", "")
                    peak_metrics = nl.split()
                    del peak_metrics[0]
                    #print(" ".join(res))
                    return peak_metrics


#***********************************************************************
def memory_processing(type_mem_dir, up_mem_dir):
    """Looping through all memory files and creating csv files"""

    # Assigning directory varibales
    kem_dir = os.path.join(up_mem_dir, "kem-mem-metrics")
    sig_dir = os.path.join(up_mem_dir, "sig-mem-metrics")
    kem_file_prefix = "kem-mem-metrics"
    sig_file_prefix = "sig-mem-metrics"
    new_row = []
    peak_metrics = []

    # file placeholders
    filednames = ["Algorithm", "Operation", "intits", "maxBytes", "maxHeap", "extHeap", "maxStack"]
    kem_operations = ["keygen", "encaps", "decaps"]
    sig_operations = ["keypair", "sign", "verify"]

    # Looping through each run count
    for run_count in range(1,16,1):

        # Creating temp dataframe
        temp_df = pd.DataFrame(columns=filednames)
        #Looping throuhg kem algorithms
        for kem_alg in kem_algs:

            kem_up_filename_pre = os.path.join(kem_dir,kem_file_prefix)

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
        kem_end = "kem-mem-metrics-" + str(run_count) + ".csv"
        kem_filename = os.path.join(type_mem_dir, kem_end)
        temp_df.to_csv(kem_filename, index=False)


        #Looping throuhg sig algorithms
        for sig_alg in sig_algs:

            sig_up_filename_pre = os.path.join(sig_dir, sig_file_prefix)

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
        sig_end = "sig-mem-metrics-" + str(run_count) + ".csv"
        sig_filename = os.path.join(type_mem_dir, sig_end)
        temp_df.to_csv(sig_filename, index=False)


#***********************************************************************
def process_tests(num_machines):
    """This function parases the results for multiple machines and stores them as csv files"""

    # Declaring directory variables
    results_dir = os.path.join(root_dir, "results")
    mem_dir = os.path.join(results_dir, "liboqs", "mem-results")
    speed_dir = os.path.join(results_dir, "liboqs", "speed-results")
    up_mem = os.path.join(root_dir, "up-results", "liboqs", "mem-results")
    up_speed = os.path.join(root_dir, "up-results", "liboqs", "speed-results")
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

        type_name = "machine-" + str(machine_num)

        # Setting up directory path
        up_speed_dir = os.path.join(up_speed, type_name)
        up_mem_dir = os.path.join(up_mem, type_name)

        # Creating specifc result directories and clearing old results
        try: 
            
            # Speed result directories
            type_speed_dir = os.path.join(speed_dir, type_name)
            os.makedirs(type_speed_dir)

            # Mem result directories
            type_mem_dir = os.path.join(mem_dir, type_name)
            os.makedirs(type_mem_dir)

        except:

            # Setting the directory variables
            type_speed_dir = os.path.join(speed_dir, type_name)
            type_mem_dir = os.path.join(mem_dir, type_name)

            #Clearing the old results and making directories
            shutil.rmtree(type_speed_dir)
            shutil.rmtree(type_mem_dir)
            os.makedirs(type_speed_dir)
            os.makedirs(type_mem_dir)

        # Parsing results
        speed_processing(type_speed_dir, up_speed_dir)
        memory_processing(type_mem_dir, up_mem_dir)
        gen_averages(type_speed_dir, type_mem_dir, root_dir)


#***********************************************************************  
def main():
    """Main function for parsing the test results"""

    # Setting up the script
    print("Preparing to Parse Results:\n")
    get_system_type()
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
    print(f"\nResults have been processed - CSV files can be found in the Results Directory at the repo root\n")


#***********************************************************************
"""Main boiler plate"""
if __name__ == "__main__":
    main()
