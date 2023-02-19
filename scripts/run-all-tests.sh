#!/bin/bash

# Declaring directory variables
root_dir="/pqc/pqc-eval-tools"
b_txt="build-type.txt"

#****************************************************************
: '
Getting if tests being done will compare mutliple machine
'
# Getting y/n input from user and stroing result
while true; 
do
    read -p "Do you intened to compare the results agaisnt other machiens [y/n]? - " response_1
    case $response_1 in

        [Yy]* ) answer="yes"; break;;

        [Nn]* ) answer="no"; break;;

        * ) echo -e "\nPlease answer y/n\n";;
    esac
done

echo -e "\n"

# Getting the machine number from the user to be used when saving results
if [ "$answer" == "yes" ]; 
then
    while true; 
    do
        read -p "What machine number would you like to assign to these results? - " response_2
        case $response_2 in

            # Asking the user to enter a number
            ''|*[!0-9]*) echo -e "\nlease enter a number\n"; 
            continue;;

            # If a number is entred by the user it is stored for later use
            * ) machine_num="$response_2"; echo -e "\nMachine number set to $response_2 \n"; 
            break;;

        esac
    done
else
    # Using default value
    echo -e "Using default name for saving results\n"
fi

#****************************************************************
: '
Performing setup of test suite
'

echo -e "Preparing Test Suite\n"

# Checking if the build directories already exist
if [ -d "/pqc/pqc-eval-tools/builds/x86-liboqs-linux" ] || [ -d "/pqc/pqc-eval-tools/builds/arm-liboqs-linux" ]; 
then
    echo -e "There is current build available - skipping build\n"
else
    if [ "$(uname -m)" = "x86_64" ] && [ "$(uname -s)" = "Linux" ]; 
    then
        # x86 Linux
        echo -e "x86-Linux Detected - creating relevant build\n"
        ./x86-linux-build.sh
        build_filename="$root_dir/result-processing/$b_txt"
        echo "x86-linux-build" > $build_filename

    elif [ "$(uname -m)" = arm* ]; 
    then
        # ARM
        echo -e "ARM Linux Detected - creating relevant build\n"
        ./arm-linux-build.sh
        build_filename="$root_dir/result-processing/$b_txt"
        echo "arm-linux-build" > $build_filename

    else
        # Unsupported system
        echo "Unsupported System Detected - Manual Build Required!\n"
        exit 1
    fi
fi


# Creating unparsed results directory and clearing old results if present
if [ -d "/pqc/pqc-eval-tools/up-results" ]; 
then
    sudo rm -r "$root_dir"/up-results/
    mkdir -p "$root_dir"/up-results/liboqs/speed-results
    mkdir -p "$root_dir"/up-results/liboqs/mem-results/
    mkdir -p "$root_dir"/up-results/liboqs/mem-results/kem-mem-metrics/ && mkdir -p "$root_dir"/up-results/liboqs/mem-results/sig-mem-metrics/
else
    mkdir -p "$root_dir"/up-results/liboqs/speed-results
    mkdir -p "$root_dir"/up-results/liboqs/mem-results/
    mkdir -p "$root_dir"/up-results/liboqs/mem-results/kem-mem-metrics/ && mkdir -p "$root_dir"/up-results/liboqs/mem-results/sig-mem-metrics/
fi

# configuring scripts
chmod +x *.sh

#****************************************************************
: '
Conducting liboqs benchmarking tests
'
cd "$root_dir"/scripts

# Memory tests
./liboqs-mem-test.sh

# CPU speed tests
./liboqs-speed-test.sh



#****************************************************************
: '
Assigning machine number to result direcotries if requested by the user
'
#Checking if assinged number has been reuquested
if [ "$answer" == "yes" ];
then

    # Creating directory name variables
    machine_direc"machine-$machine_num"

    # Changing result directory names for liboqs
    mkdir -p "$root_dir"/up-results/liboqs/speed-results/"$machine_direc"
    mkdir -p "$root_dir"/up-results/liboqs/mem-results/"$machine_direc"
    mv "$root_dir"/up-results/liboqs/mem-results/kem-mem-metrics "$root_dir"/up-results/liboqs/mem-results/"$machine_direc"/
    mv "$root_dir"/up-results/liboqs/mem-results/sig-mem-metrics "$root_dir"/up-results/liboqs/mem-results/"$machine_direc"/
    mv "$root_dir"/up-results/liboqs/speed-results/results "$root_dir"/up-results/liboqs/speed-results/"$machine_direc"

fi