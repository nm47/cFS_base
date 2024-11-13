# Start from the Ubuntu 20.04 base image
FROM ubuntu:20.04 as cfs_base
ARG USERNAME=cfs_user

# Set a non-interactive shell environment
ENV DEBIAN_FRONTEND=noninteractive

# Install cFS dependencies
RUN apt-get update && \
    apt-get install -y \
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

RUN useradd -m ${USERNAME} && \
    git clone --recursive https://github.com/nasa/cFS.git /home/${USERNAME}/cFS

WORKDIR /home/${USERNAME}/cFS
RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/cFS && \
    cd /home/${USERNAME}/cFS && \
    cp cfe/cmake/Makefile.sample Makefile && \
    cp -r cfe/cmake/sample_defs sample_defs && \
    make SIMULATION=native prep && \
    make && \
    make install

CMD ["bash"]
