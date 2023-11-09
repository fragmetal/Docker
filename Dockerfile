FROM ubuntu:latest

# Set noninteractive environment variables for apt
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

# Install necessary packages
RUN apt update && apt upgrade -y && \
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
    apt update && apt upgrade -y && \
    apt install -y python3.11

# Install pip for Python 3.11
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.11 get-pip.py

# Install Cloudflare service
RUN curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && dpkg -i cloudflared.deb && \
    cloudflared service install eyJhIjoiN2Q4ZGI3YTgzODU5MjQxZDdmMDI4ZmM2MjhkOTcxNmMiLCJ0IjoiMmYzMWQ2NTItN2IwNS00Mzc1LTliYzEtYmI4OGNiYmY1MjU4IiwicyI6Ik4yVXdaREl5TkRRdFpXUmpOaTAwWTJZeExUaGpaREV0TURVM05EbG1ZekJpTnpkbCJ9

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

# Start shellinabox and install Cloudflare service
CMD /usr/bin/shellinaboxd -t -s /:LOGIN

