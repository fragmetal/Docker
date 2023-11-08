FROM ubuntu:latest

# Install necessary packages
RUN apt update && \
    apt install -y systemd software-properties-common lsb-release nano tar curl git htop neofetch shellinabox

# Install Node.js
RUN curl -O https://nodejs.org/download/release/v18.18.2/node-v18.18.2-linux-x64.tar.gz && \
    tar -xvf node-v18.18.2-linux-x64.tar.gz && \
    mv node-v18.18.2-linux-x64 /usr/local/lib/nodejs

# Set up some configurations
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    echo 'root:Sadri@123' | chpasswd && \
    echo "export PATH=/usr/local/lib/nodejs/bin:\$PATH" >> ~/.bashrc && \
    bash -c "source ~/.bashrc"

# Install Cloudflare service
RUN curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && dpkg -i cloudflared.deb && \
    cloudflared service uninstall && \
    cloudflared service install eyJhIjoiN2Q4ZGI3YTgzODU5MjQxZDdmMDI4ZmM2MjhkOTcxNmMiLCJ0IjoiMmYzMWQ2NTItN2IwNS00Mzc1LTliYzEtYmI4OGNiYmF5MjU4IiwicyI6Ik1ESXdZV1JsWW1ZdE5qTTBZeTAwTldRNExXRmhObUV0WlRrM1lqVmtNV0ZrWVdGaiJ9

# Clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose the SSH port
EXPOSE 4200

# Start shellinabox
CMD ["/usr/bin/shellinaboxd", "-t", "-s", "/:LOGIN"]
