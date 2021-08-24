FROM buildpack-deps:bionic

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    sudo \ 
    nano \
    software-properties-common

ENV LANG=en_US.UTF-8

### Git ###
RUN add-apt-repository -y ppa:git-core/ppa \
    && apt-get install -yq --no-install-recommends git git-lfs

### Gitpod user ###
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
ENV HOME=/home/gitpod
WORKDIR $HOME

USER gitpod

# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for Gitpod: success" && \
    mkdir /home/gitpod/.bashrc.d && \
    (echo; echo "for i in \$(ls \$HOME/.bashrc.d/*); do source \$i; done"; echo) >> /home/gitpod/.bashrc

# configure git-lfs
RUN sudo git lfs install --system