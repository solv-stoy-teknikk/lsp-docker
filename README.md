# LSP Plugins Docker Build

This repository provides a Dockerized build environment for the [Linux Sound Project's main plugin repository (lsp-plugins)](https://github.com/lsp-plugins/lsp-plugins).

## Overview

Easily build and test LSP Plugins in a consistent, isolated Docker environment. This is useful for development, CI/CD, or simply running the plugins without polluting your host system.

## Usage

### 1. Clone this repository

```sh
git clone https://github.com/your-username/lsp-docker.git
cd lsp-docker
```

### 2. Build the Docker image

```sh
docker build -t lsp-plugins .
```

### 3. Run the build

```sh
docker run --rm -it lsp-plugins
```

By default, the container will clone and build the latest version of `lsp-plugins`.

## Customization

To build a specific branch or commit, modify the `Dockerfile` as needed.

## Volumes

To access build artifacts on your host, mount a volume:

```sh
docker run --rm -it -v $(pwd)/output:/output lsp-plugins
```

## License

This repository is licensed under the GNU General Public License v3.0 (GPL-3.0). The LSP Plugins project is licensed separately; see their [repository](https://github.com/lsp-plugins/lsp-plugins) for details.

## Credits

- [LSP Plugins](https://github.com/lsp-plugins/lsp-plugins)
- Docker community
