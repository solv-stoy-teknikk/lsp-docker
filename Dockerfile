FROM debian:bookworm
LABEL maintainer="S Davis <sdavis@nativeit.net>"

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
    # Make dirs
    && mkdir -p /build \
    # Clean up apt cache
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /build

# Mount point for source code
VOLUME ["/build"]

# Clone the current git repository with submodules
RUN git clone --recurse-submodules https://github.com/solv-stoy-teknikk/lsp-docker /build/lsp-docker

# Set working directory
WORKDIR /build/lsp-docker/src/lsp-plugins

# Build the project
RUN make config && \
    make fetch && \
    make && \
    make install && \
    mkdir -p /build/lsp-docker/output && \
    mv -r ./build/target/* /build/lsp-docker/output/ && \
    tar -czf /build/lsp-docker/output.tar.gz -C /build/lsp-docker/output . && \
    make clean && \
    git add /build/lsp-docker/output.tar.gz && \
    git commit -m "Build output tarball" || true && \
    git push origin main || true
# Default command

CMD ["/bin/bash"]
