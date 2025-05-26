FROM debian:bookworm
LABEL maintainer="Solv Støy Teknikk"

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    git \
    libsndfile1-dev \
    libfftw3-dev \
    libsamplerate0-dev \
    libx11-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libjack-jackd2-dev \
    libasound2-dev \
    libgtk-3-dev \
    liblo-dev \
    libcurl4-openssl-dev \
    python3 \
    python3-pip \
    php \
    php-cli \
    php-curl \
    php-xml \
    php-mbstring \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    # Clone the current git repository with submodules
    RUN git clone --recurse-submodules https://github.com/solv-stoy-teknikk/lsp-docker /opt/lsp-docker


# Set working directory
WORKDIR /opt/lsp-docker/src/lsp-plugins

# Build the project
RUN make config && \
    make fetch && \
    make && \
    make install && \
    mkdir -p /opt/lsp-docker/build_output && \
    cp -r .build/target/* /opt/lsp-docker/build_output/ && \
    tar -czf /opt/lsp-docker/lsp-plugins.tar.gz -C /opt/lsp-docker/build_output .

# Default command
CMD ["/bin/bash"]

