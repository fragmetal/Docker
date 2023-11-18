FROM ubuntu:latest

# Install necessary packages
RUN apt update && apt upgrade -y && \
    apt install -y systemd software-properties-common lsb-release nano tar curl git htop neofetch shellinabox
    
# Automatically configure the timezone (based on VPS location)
RUN echo "tzdata tzdata/Areas select Etc" | debconf-set-selections && \
    echo "tzdata tzdata/Zones/Etc select UTC" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt install -y tzdata
    
# Set up some configurations
RUN echo 'root:Sadri@123' | chpasswd && \
    echo "alias ll='ls -l'" > /etc/profile.d/ll.sh && \
    bash -c "source ~/.bashrc"
    
# Clone the Lavalink repository
RUN git clone https://github.com/fragmetal/lavalink.git

# Change the working directory to the cloned repository
WORKDIR /lavalink

# Give execution permissions to the start.sh script
RUN chmod +x ./start.sh

# Clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose the port
EXPOSE 443

CMD ["./start.sh"]
