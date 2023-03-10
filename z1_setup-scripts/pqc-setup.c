#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>

void download() {
    // Function for setting up the repo
    system("sudo mkdir /pqc && cd /pqc");
    system("sudo chown -R $USER /pqc && sudo chmod -R 755 /pqc");
    system("git clone https://github.com/crt2626/pqc-eval-tools.git");
    system("git clone https://github.com/crt2626/pqc-docker.git");
    system("sudo chown -R $USER /pqc/ && sudo chmod -R 755 /pqc");
    system("chmod +x /pqc/pqc-eval-tools/scripts/*.sh && chmod +x /pqc/pqc-eval-tools/result-processing/parsing-scripts/*.py");
    system("mkdir -p /pqc/output && mkdir -p /pqc/output/op1 && mkdir -p /pqc/output/op2 && mkdir -p /pqc/output/op3");
    system("echo \"0\" > /pqc/pqc-eval-tools/backup.flag");
}

void dependency_install() {
    // Check for and install required packages
    char* packages[] = {"git", "astyle", "cmake", "gcc", "ninja-build", "libssl-dev", "python3-pytest", "python3-pytest-xdist", "unzip", "xsltproc", "doxygen", "graphviz", "python3-yaml", "valgrind", "python3-pip", "rsync", "smbclient", "cifs-utils", NULL};
    char cmd[200] = {0};
    char* not_installed[20];
    int i, n = 0;
    for (i = 0; packages[i] != NULL; i++) {
        sprintf(cmd, "dpkg -s %s >/dev/null 2>&1", packages[i]);
        if (system(cmd) != 0) {
            not_installed[n++] = packages[i];
        }
    }
    if (n != 0) {
        system("sudo apt-get update");
        sprintf(cmd, "sudo apt-get install -y %s", not_installed[0]);
        for (i = 1; i < n; i++) {
            sprintf(cmd + strlen(cmd), " %s", not_installed[i]);
        }
        system(cmd);
    }

    // Installing needed python modules
    system("pip install pandas");
    system("pip install matplotlib");
}

int main() {
    // Checking if the directory is already there
    struct stat sb;
    if (stat("/pqc", &sb) == 0 && S_ISDIR(sb.st_mode)) {
        chdir("/pqc");
        system("sudo rm -r pqc-docker && sudo rm -r pqc-eval-tools");
        download();
        dependency_install();
    } else {
        download();
        dependency_install();
    }

    // Setting backup flag
    system("echo \"0\" > /pqc/pqc-eval-tools/backup.flag");

    printf("\nRepo has been setup in the /pqc directory\n");

    return 0;
}
