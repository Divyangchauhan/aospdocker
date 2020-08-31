FROM ubuntu:18.04

LABEL maintainer="Divyang Chauhan <divyang@divyangchauhan.com>"

WORKDIR /root/

ENV USER aosp

RUN apt-get update

#install essential build
RUN apt-get install -y git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig build-essential openssh-server

#RUN ufw allow ssh
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd
RUN useradd -m -G wheel -s /bin/bash aosp
RUN echo 'aosp:aosp' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo
RUN chmod a+x /bin/repo


#copy the entry script into the container

#set volume
RUN mkdir /aosp

WORKDIR /aosp

EXPOSE 22
