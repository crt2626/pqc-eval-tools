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

    # Looping through the kem algorithms
    for kem_alg in kem_algs:

        temp_df1 = pd.DataFrame(columns=mem_fieldnames)

        # Looping throuhg the run files
        for run_count in range(1,16,1):

            # Setting filename and reading csv into dataframe
            kem_mem_filename = kem_mem_file_prefix + str(run_count) + ".csv"
            temp_df2 = pd.read_csv(kem_mem_filename)

            #Getting the algorithm operations across all files into one
            temp_df2 = temp_df2.loc[temp_df2["Algorithm"].str.contains(kem_alg)]
            temp_df1 = pd.concat([temp_df2, temp_df1], ignore_index=True, sort=False)

        #Getting the avereages for each operation

        for operation in kem_operations:
            temp_df3 = temp_df1.loc[temp_df1["Operation"].str.contains(operation)]
            keygen_averages = temp_df3.select_dtypes(include=['int', 'float']).mean()
            print(keygen_averages)
        break



import pandas as pd

# Select only the numeric columns and calculate the average
keygen_averages = keygen_df.select_dtypes(include=['int', 'float']).mean()

# Create a new DataFrame with the same structure as keygen_df
averages_df = pd.DataFrame(columns=keygen_df.columns)

# Set the average values in the new DataFrame
averages_df.loc[0] = keygen_averages

# Print the new DataFrame
print(averages_df)

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
    