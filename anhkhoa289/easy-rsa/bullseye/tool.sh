#!/bin/sh
set -e

./easyrsa init-pki

echo "$SERVER_NAME" | ./easyrsa gen-req server nopass
cp ./pki/private/server.key /etc/openvpn/server/

echo "$SERVER_NAME" | ./easyrsa build-ca nopass
echo "yes" | ./easyrsa sign-req server server
cp ./pki/issued/server.crt /etc/openvpn/server
cp ./pki/ca.crt /etc/openvpn/server




openvpn --genkey secret ta.key
cp ta.key /etc/openvpn/server





mkdir -p ~/client-configs/keys
chmod -R 700 ~/client-configs



echo "client1" | ./easyrsa gen-req client1 nopass
cp ./pki/private/client1.key ~/client-configs/keys/
echo "yes" | ./easyrsa sign-req client client1
cp ./pki/issued/client1.crt ~/client-configs/keys/
cp ta.key ~/client-configs/keys/
cp /etc/openvpn/server/ca.crt ~/client-configs/keys/
