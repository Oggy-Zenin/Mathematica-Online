FROM jupyter/base-notebook:latest

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    libxt6 \
    libxrender1 \
    libxext6 \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# Copy Wolfram installer script
COPY scripts/install_wolfram.sh /tmp/install_wolfram.sh
RUN chmod +x /tmp/install_wolfram.sh && /tmp/install_wolfram.sh

# Environment for Wolfram
ENV WOLFRAM_INSTALLATION_DIRECTORY=/usr/local/Wolfram
ENV PATH="$WOLFRAM_INSTALLATION_DIRECTORY/Executables:$PATH"

# Copy paclet (offline install)
COPY paclets/ /opt/paclets/

# Copy install script
COPY scripts/install_paclet.wls /tmp/install_paclet.wls

# Install paclet
RUN wolframscript -file /tmp/install_paclet.wls

# Install Python deps
COPY requirements.txt .
RUN pip install -r requirements.txt

USER $NB_UID
