FROM alpine:3.18


RUN set -eux; apk add --no-cache openvpn easy-rsa

RUN mkdir ~/easy-rsa
RUN ln -s /usr/share/easy-rsa/* ~/easy-rsa/
RUN chmod 700 ~/easy-rsa

WORKDIR /root/easy-rsa
