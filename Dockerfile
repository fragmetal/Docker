FROM ubuntu:latest

# Set noninteractive environment variables for apt
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

# Install necessary packages
RUN apt update && \
    apt install -y systemd software-properties-common lsb-release nano tar curl git htop neofetch shellinabox

# Automatically configure the timezone (based on VPS location)
RUN echo "tzdata tzdata/Areas select Etc" | debconf-set-selections && \
    echo "tzdata tzdata/Zones/Etc select UTC" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt install -y tzdata

# Install Node.js
RUN curl -O https://nodejs.org/download/release/v18.18.2/node-v18.18.2-linux-x64.tar.gz && \
    tar -xvf node-v18.18.2-linux-x64.tar.gz && \
    rm node-v18.18.2-linux-x64.tar.gz && \
    mv node-v18.18.2-linux-x64 /usr/local/lib/nodejs

# Install Python 3.11
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt update && \
    apt install -y python3.11

# Install pip for Python 3.11
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.11 get-pip.py

# Create a virtual environment
RUN python3.11 -m venv venv

# Install Cloudflare service
RUN curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && dpkg -i cloudflared.deb

# Set up some configurations
RUN ln -s /usr/bin/python3.11 /usr/bin/python && \
    echo 'root:Sadri@123' | chpasswd && \
    echo "alias ll='ls -l'" > /etc/profile.d/ll.sh && \
    echo "export PATH=/usr/local/lib/nodejs/bin:\$PATH" >> ~/.bashrc && \
    bash -c "source ~/.bashrc"

# Clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose the SSH port
EXPOSE 4200

# Start shellinabox
CMD ["/usr/bin/shellinaboxd", "-t", "-s", "/:LOGIN"]
