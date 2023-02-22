"""Importing modules and declaring Global Variables"""
# Importing
import pandas as pd
import re
import os
import shutil


#***********************************************************************  
def gen_averages(type_speed_dir, type_mem_dir):
    """Function for generating averages csv files for all tests"""

    # Declaring directories variables
    kem_speed_file_prefix = type_speed_dir + "test-kem-speed-"
    sig_speed_file_prefix = type_speed_dir + "test-sig-speed-"
    kem_mem_file_prefix = type_mem_dir + "kem-mem-metrics-"
    sig_mem_file_prefix = type_mem_dir + "sig-mem-metrics-"

    # Declaring dataframes and fieldnames
    mem_fieldnames = ["Algorithm", "Operation", "intits", "maxBytes", "maxHeap", "extHeap", "maxStack"]
    speed_fieldnames = ["Algorithm", "Operation", ""]
    kem_mem_avg = pd.DataFrame(columns=mem_fieldnames)

    # kem_mem_filename = kem_mem_file_prefix + str(run_count) + ".csv"
    # kem_speed_filename = sig_mem_file_prefix + str(run_count) + ".csv"


    """Getting the averages for the memory results"""
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

        print(temp_df1)
        break




def avg_mem():
    """Taking in the provided machine mem results and 
    generating an avereage for all the runs"""

    





def gen_avereages():
