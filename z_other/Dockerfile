# Build and access comands
# Build:
# docker build -t *name-of-image* *dockerfile filepath*
# docker build -t test ./
#Run:
# run docker machine in interactive mode, specicey to use bash shell
#docker run -it /bin/bash 
#*********************************************************************

FROM debian:bullseye

ENV DEBIAN_FRONTEND noninteractive

# Get all software packages required for building liboqs
RUN apt-get update && \
    apt-get install -y \
    astyle \
    build-essential \
    cmake \
    gcc \
    graphviz \
    libssl-dev \
    ninja-build \
    python3-pytest \
    python3-pytest-xdist \
    python3-yaml \
    python3-pip \
    sudo \
    unzip \
    valgrind \
    vim \
    nano \
    iproute2 \
    python3 \
    xsltproc \
    doxygen \ 
    git \ 
    wget 

#Setting root password
RUN echo 'root:password' | chpasswd

# create a user with root privileges
RUN useradd --no-log-init --system --uid 1000 --create-home testuser

# set working directory
WORKDIR /home/testuser

# Clone the better liboqs (better cause of me, duh tots obvs #supieor_intelect #basic-bitch #) repository and build the library
RUN wget https://github.com/crt2626/pqc-eval-tools/blob/main/setup.sh
RUN chmod +x setup.sh
RUN mkdir /pqc
WORKDIR /pqc
RUN git clone https://github.com/crt2626/pqc-eval-tools.git
RUN chown -R testuser:testuser /pqc
RUN chmod -R 755 /pqc

# set working directory
WORKDIR /home/testuser
RUN pip install pandas
RUN pip install matplotlib

# switch to the new user
USER testuser
