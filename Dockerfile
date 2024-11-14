# Start from the Ubuntu 20.04 base image
FROM ubuntu:20.04

# Set a non-interactive shell environment
ENV DEBIAN_FRONTEND=noninteractive

# Install cFS dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        python3-dev \
        python3-pip \
        python3-pyqt5 \
        python3-zmq \
        sudo \
        git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root/cfs_ws
RUN git clone --recursive https://github.com/nasa/cFS.git .

# Prepare and build cFS
RUN cp cfe/cmake/Makefile.sample Makefile && \
    cp -r cfe/cmake/sample_defs sample_defs && \
    make SIMULATION=native prep && \
    make && \
    make install

# Set default command
CMD ["bash"]

