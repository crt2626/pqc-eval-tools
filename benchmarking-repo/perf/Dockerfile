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
    build-essential \
    cmake \
    git \
    libssl-dev \
    ninja-build \
    sudo

#Setting root password
RUN echo 'root:password' | chpasswd

# Clone the liboqs repository and build the library
WORKDIR /opt
RUN git clone --depth 1 --branch main https://github.com/open-quantum-safe/liboqs.git
WORKDIR /opt/liboqs
RUN mkdir build && cd build && cmake .. ${LIBOQS_BUILD_DEFINES} -DCMAKE_INSTALL_PREFIX=${INSTALLDIR} && make ${MAKE_DEFINES} && make install

# Copy required executables to INSTALLDIR
RUN cp build/tests/test_kem ${INSTALLDIR}/bin/ && \
    cp build/tests/test_sig ${INSTALLDIR}/bin/ && \
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

