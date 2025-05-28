### Dockerfile

```dockerfile
# Use the official Debian Bookworm as the base image
FROM debian:bookworm

# Set the maintainer label
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

# Set the working directory to the lsp-plugins source directory
WORKDIR /opt/lsp-docker/src/lsp-plugins

# Build the project
RUN make config && \
    make fetch && \
    make && \
    make install && \
    mkdir -p /opt/lsp-docker/build_output && \
    cp -r .build/target/* /opt/lsp-docker/build_output/ && \
    tar -czf /opt/lsp-docker/lsp-plugins.tar.gz -C /opt/lsp-docker/build_output .

# Set the default command to bash
CMD ["/bin/bash"]
```

### Instructions to Build and Run the Docker Container

1. **Save the Dockerfile**: Ensure the above Dockerfile is saved in the directory where your project is located (e.g., `/home/native/dev/projects/lsp-docker/Dockerfile`).

2. **Build the Docker Image**: Open a terminal and navigate to the directory containing the Dockerfile. Run the following command to build the Docker image:

   ```bash
   docker build -t lsp-plugins-build .
   ```

3. **Run the Docker Container**: After the image is built, you can run a container from the image using:

   ```bash
   docker run -it --rm lsp-plugins-build
   ```

   This command will start a new container and drop you into a bash shell where you can interact with the environment.

### Notes

- The `--rm` flag automatically removes the container when it exits, keeping your environment clean.
- You can modify the Dockerfile further based on specific needs or additional dependencies for your project.
- If you need to persist the build output or share it with your host machine, consider using Docker volumes. For example:

   ```bash
   docker run -it --rm -v $(pwd)/build_output:/opt/lsp-docker/build_output lsp-plugins-build
   ```

This command mounts the `build_output` directory from your host to the container, allowing you to access the built files directly on your host machine.