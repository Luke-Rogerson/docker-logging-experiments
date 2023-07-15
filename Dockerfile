# This creates a temp image simulating an Ubuntu EC2 to test the installer script

FROM ubuntu:22.10
ARG DEBIAN_FRONTEND=noninteractive

# Add sudo to make more like EC2 instance
RUN apt-get update && apt-get install -y software-properties-common python3 python3-pip sudo locales software-properties-common curl git cron ca-certificates gnupg

# Docker + Docker Compose v2
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# EC2 instances usually have locale settings
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8 \
  LANGUAGE=en_US:en \
  LC_ALL=en_US.UTF-8

# Needed to allow crons to run in the container
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

WORKDIR /home/ubuntu

COPY . .

CMD ["/bin/bash"]

# https://bobcares.com/blog/error-couldnt-connect-to-docker-daemon/
# sudo service docker start