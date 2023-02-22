FROM debian:bullseye

# Default location where all binaries wind up:
ARG INSTALLDIR=/opt/oqssa

# liboqs build defines (https://github.com/open-quantum-safe/liboqs/wiki/Customizing-liboqs)
ARG LIBOQS_BUILD_DEFINES=""

# Define the degree of parallelism when building the image
ARG MAKE_DEFINES="-j 8"

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
    sudo \
    unzip \
    valgrind \
    vim \
    nano \
    iproute2 \
    python3 \
    xsltproc \
    doxygen \ 
    git

#Setting root password
RUN echo 'root:password' | chpasswd

# create a user with root privileges
RUN useradd --no-log-init --system --uid 1000 --create-home testuser

# switch to the new user
USER testuser

# set working directory
WORKDIR /home/testuser



# Clone the better liboqs (better cause of me, duh tots obvs #supieor_intelect #basic-bitch #) repository and build the library
RUN wget https://github.com/crt2626/pqc-eval-tools/blob/main/setup.sh
RUN git clone --depth 1 --branch main https://github.com/crt2626/pqc-eval-tools.git


WORKDIR /opt/liboqs
RUN mkdir build && cd build && cmake .. ${LIBOQS_BUILD_DEFINES} -DCMAKE_INSTALL_PREFIX=${INSTALLDIR} && make ${MAKE_DEFINES} && make install

# Create bin directory in INSTALLDIR
RUN mkdir -p ${INSTALLDIR}/bin && \
    cp build/tests/speed_kem ${INSTALLDIR}/bin/ && \
    cp build/tests/speed_sig ${INSTALLDIR}/bin/ && \
    cp build/tests/test_kem_mem ${INSTALLDIR}/bin/ && \
    cp build/tests/test_sig_mem ${INSTALLDIR}/bin/


WORKDIR /repo
RUN git clone --depth 1 --branch main https://github.com/40428470/pqc-eval-tools.git


# create a user with root privileges
RUN useradd --no-log-init --system --uid 1000 --create-home testuser

# switch to the new user
USER testuser

# set working directory
WORKDIR /home/testuser

