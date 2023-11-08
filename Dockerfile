FROM debian:latest

# Install necessary packages
RUN apt-get update && \
    apt install -y systemd nano software-properties-common curl lsb-release wget git htop neofetch && \
    curl -O https://nodejs.org/download/release/v18.18.2/node-v18.18.2-linux-x64.tar.gz && \
    tar -xvf node-v18.18.2-linux-x64.tar.gz;mv node-v18.18.2-linux-x64 /usr/local/lib/nodejs && \
    echo "export PATH=/usr/local/lib/nodejs/bin:$PATH" >> ~/.bashrc && \
    echo "alias python=python3" >> ~/.bashrc; source ~/.bashrc

# Install necessary packages
RUN apt update && \
    apt install -y shellinabox && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set root password
RUN echo 'root:Sadri@123' | chpasswd

# Expose the SSH port
EXPOSE 4200

# Start shellinabox
CMD ["/usr/bin/shellinaboxd", "-t", "-s", "/:LOGIN"]
