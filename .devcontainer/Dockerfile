FROM ubuntu:22.04

# Install essentials
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       wget \
       curl \
       bzip2 \
       git \
       build-essential \
       tar \
       libgl1 \
       libxrender1 \
       libxtst6 \
       libxext6 \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda to /opt/conda
ENV CONDA_DIR=/opt/conda
ENV PATH="${CONDA_DIR}/bin:${PATH}"
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p ${CONDA_DIR} \
    && rm /tmp/miniconda.sh \
    && ${CONDA_DIR}/bin/conda clean -afy

# Copy environment.yml and create the conda environment from it
COPY ../environment.yml /tmp/environment.yml
# Ensure Conda Terms of Service are accepted for Anaconda channels used by `defaults`
# Accepting explicitly for repo.anaconda.com/pkgs/main and repo.anaconda.com/pkgs/r
RUN /opt/conda/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main || true \
    && /opt/conda/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r || true \
    && /opt/conda/bin/conda env create -f /tmp/environment.yml -n dev \
    && /opt/conda/bin/conda clean -afy

# Register the kernel for convenience (so notebooks see the env)
RUN /opt/conda/bin/conda run -n dev python -m ipykernel install --name=devcontainer --display-name "devcontainer (conda)" || true

# Create workspace folder and set ownership to vscode user that will be created later
RUN useradd -m -s /bin/bash vscode \
    && mkdir -p /workspace \
    && chown -R vscode:vscode /workspace

# Install Starship prompt and configure it for the vscode user
RUN ARCH="x86_64-unknown-linux-gnu" && \
    wget -qO /tmp/starship.tar.gz "https://github.com/starship/starship/releases/latest/download/starship-${ARCH}.tar.gz" && \
    mkdir -p /tmp/starship && tar -xzf /tmp/starship.tar.gz -C /tmp/starship && \
    mv /tmp/starship/starship /usr/local/bin/starship && chmod +x /usr/local/bin/starship && \
    rm -rf /tmp/starship /tmp/starship.tar.gz && \
    mkdir -p /home/vscode/.config && \
    chown -R vscode:vscode /home/vscode/.config /home/vscode/.bashrc

COPY .devcontainer/starship.toml /home/vscode/.config/starship.toml
RUN echo 'eval "$(starship init bash)"' >> /home/vscode/.bashrc && chown vscode:vscode /home/vscode/.config/starship.toml

USER vscode
WORKDIR /workspace

EXPOSE 8888

# Prevent CMD from attempting to start services when VS Code runs the container
CMD ["bash", "-lc", "tail -f /dev/null"]
