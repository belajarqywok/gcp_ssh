#!/bin/bash

cat << EOF >> Dockerfile

FROM ubuntu:18.04

LABEL ig="@otw.mastah" author="Initial R"

RUN apt-get update && apt-get install -y openssh-server && apt-get install -y mysql-client

RUN mkdir /var/run/sshd

RUN echo "$USERNAME:$PASSWORD" | chpasswd

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

EXPOSE $PORT

CMD ["/usr/sbin/sshd","-D"]

EOF

docker build --tag qywok/gcp-ssh:1.0 .
docker push qywok/gcp-ssh:1.0