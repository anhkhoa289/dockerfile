FROM debian:bullseye-slim

RUN set -eux; apt-get update;
RUN set -eux; apt install -y openvpn easy-rsa

RUN mkdir ~/easy-rsa
RUN ln -s /usr/share/easy-rsa/* ~/easy-rsa/
RUN chmod 700 ~/easy-rsa


ENV SERVER_NAME=basshub

WORKDIR /root/easy-rsa

COPY --chmod=700 vars tool.sh ./
