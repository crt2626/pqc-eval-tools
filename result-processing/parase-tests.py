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
kem_algs=[]
sig_algs=[]


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


def speed_processing():
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
