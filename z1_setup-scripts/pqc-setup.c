#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

/*Global Variables*/
//Directory Paths
char root_dir[5] = "/pqc";
char make_dir_cmd[265] = ""

void download() {
    // Function for setting up the repo
    system("sudo mkdir /pqc");
    chdir("/pqc");
    system("git clone https://github.com/crt2626/pqc-eval-tools.git");
    system("chown -R $USER /pqc/");
    system("chmod -R 755 /pqc");
    chdir("/pqc/pqc-eval-tools/scripts");
    system("chmod +x /pqc/pqc-eval-tools/scripts/*.sh");
}

void dependency_install() {

    // Check for and install required packages
    const char* packages[] = {"astyle", "cmake", "gcc", "ninja-build", "libssl-dev", "python3-pytest", "python3-pytest-xdist", "unzip", "xsltproc", "doxygen", "graphviz", "python3-yaml", "valgrind", "python3-pip"};
    int num_packages = sizeof(packages) / sizeof(packages[0]);
    char command[256];
    for (int i = 0; i < num_packages; i++) {
        snprintf(command, sizeof(command), "dpkg -s %s >/dev/null 2>&1", packages[i]);
        if (system(command) != 0) {
            snprintf(command, sizeof(command), "apt-get install -y %s", packages[i]);
            system("apt-get update");
            system(command);
        }
    }

    system("pip install pandas");
    system("pip install matplotlib");
}

int main() {

    //Declaring command variable
    char cmd[256]
    // Checking for pqc root directory
    if (access(root_dir, F_OK) == 0) {

        //Creating directory if not present
        snprintf(cmd, sizeof(cmd), "sudo mkdir %s", root_dir);
        system(cmd);
        memset(cmd, 0, sizeof(cmd));

    }
    else {
        //Removing previous install
        system("rm -r /pqc/pqc-eval-tools");
    }
    download();
    dependency_install();
    printf("\nRepo has been setup in the /pqc directory\n");
    return 0;
}