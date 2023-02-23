"""Importing modules and declaring Global Variables"""
# Importing
import pandas as pd
import re
import os
import shutil
import sys

# Declaring gloabl variables
kem_algs = []
sig_algs = []
kem_operations = ["keygen", "encaps", "decaps"]
sig_operations = ["keypair", "sign", "verify"]
root_dir = ""

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
def avg_mem(type_mem_dir):
    """Taking in the provided machine mem results and 
    generating an avereage for all the runs"""

    # Declaring directories variables
    kem_mem_file_prefix = os.path.join(type_mem_dir, "kem-mem-metrics-")
    sig_mem_file_prefix = os.path.join(type_mem_dir, "sig-mem-metrics-")

    # Declaring dataframes and fieldnames
    mem_fieldnames = ["Algorithm", "Operation", "intits", "maxBytes", "maxHeap", "extHeap", "maxStack"]
    kem_mem_avg = pd.DataFrame(columns=mem_fieldnames)
    sig_mem_avg = pd.DataFrame(columns=mem_fieldnames)

    """Calculating KEM Averages"""
    # Looping through the kem algorithms
    for kem_alg in kem_algs:

        # Creating combined operations dataframe for current algorithm
        combined_operations = pd.DataFrame(columns=mem_fieldnames)

        # Looping throuhg the run files
        for run_count in range(1,16,1):

            # Setting filename and reading csv into dataframe
            kem_mem_filename = kem_mem_file_prefix + str(run_count) + ".csv"
            temp_df = pd.read_csv(kem_mem_filename)

            #Getting the algorithm operations across all files into one
            temp_df = temp_df.loc[temp_df["Algorithm"].str.contains(kem_alg)]
            combined_operations = pd.concat([temp_df, combined_operations], ignore_index=True, sort=False)

        #Getting the avereages for each operation
        for operation in kem_operations:
            
            # Getting a list of the operation metric averages 
            operation_average = combined_operations.loc[combined_operations["Operation"].str.contains(operation)]
            operation_average = operation_average[mem_fieldnames[2:]]

            # Calcualting Averages
            operation_average = (operation_average.mean(axis=0)).to_frame()

            #Creating new row and exporting to main kem memory average dataframe
            row = operation_average.iloc[:, 0].to_list()
            row.insert(0, kem_alg)
            row.insert(1, operation)
            kem_mem_avg.loc[len(kem_mem_avg)] = row


    """Calculating Digital Signature Averages"""
    # Looping throuhg digital signature algorithms
    for sig_alg in sig_algs:

        # Creating combined operations dataframe for current algorithm
        combined_operations = pd.DataFrame(columns=mem_fieldnames)

        # Looping through run files
        for run_count in range(1,16,1):

            # Setting the filename and reading csv into dataframe
            sig_mem_filename = sig_mem_file_prefix + str(run_count) + ".csv"
            temp_df = pd.read_csv(sig_mem_filename)

            # Geting the algorithm operations across all files into one
            temp_df = temp_df.loc[temp_df["Algorithm"].str.contains(sig_alg, regex=False)]
            combined_operations = pd.concat([temp_df, combined_operations], ignore_index=True, sort=False)
        

        # Getting the averages for each operation
        for operation in sig_operations:

            # Creating a list of the operation metric averages
            operation_average = combined_operations.loc[combined_operations["Operation"].str.contains(operation, regex=False)]
            print(operation_average)
            operation_average = operation_average[mem_fieldnames[2:]]

            # Calculating averages
            operation_average = (operation_average.mean(axis=0)).to_frame()

            # Creating new row and exporting to main digital signature memory average dataframe
            row = operation_average.iloc[:, 0].to_list()
            row.insert(0, sig_alg)
            row.insert(1, operation)
            sig_mem_avg.loc[len(sig_mem_avg)] = row

        
    
    # Exporting average csv files
    kem_csv_name = os.path.join(type_mem_dir, "kem-mem-avg.csv")
    kem_mem_avg.to_csv(kem_csv_name, index=False)
    sig_csv_name = os.path.join(type_mem_dir, "sig-mem-avg.csv")
    sig_mem_avg.to_csv(sig_csv_name, index=False)


#***********************************************************************  
def gen_averages(type_speed_dir, type_mem_dir, dir):
    """Function for generating averages csv files for all tests"""

    # Setting root directory
    global root_dir 
    root_dir = dir

    # Declaring directories variables
    # kem_speed_file_prefix = type_speed_dir + "test-kem-speed-"
    # sig_speed_file_prefix = type_speed_dir + "test-sig-speed-"
    # kem_mem_file_prefix = type_mem_dir + "kem-mem-metrics-"
    # sig_mem_file_prefix = type_mem_dir + "sig-mem-metrics-"



    # setup
    get_algs()

    # Running average generation functions
    avg_mem(type_mem_dir)
    