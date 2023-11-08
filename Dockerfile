FROM debian:latest

# Install necessary packages
RUN apt-get update && \
    apt install -y systemd software-properties-common lsb-release nano curl git htop neofetch && \
    rm -rf /var/lib/apt/lists/*

RUN apt update && \
    apt install -y shellinabox && \
    curl -O https://nodejs.org/download/release/v18.18.2/node-v18.18.2-linux-x64.tar.gz && \
    tar -xvf node-v18.18.2-linux-x64.tar.gz && \
    mv node-v18.18.2-linux-x64 /usr/local/lib/nodejs && \
    echo "alias python=python3" >> /.bashrc && \
    echo 'root:Sadri@123' | chpasswd && \
    source ~/.bashrc && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
ENV PATH="/usr/local/lib/nodejs/bin:${PATH}"

# Expose the SSH port
EXPOSE 4200

# Start shellinabox
CMD ["/usr/bin/shellinaboxd", "-t", "-s", "/:LOGIN"]
