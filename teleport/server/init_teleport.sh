#!/bin/bash
SERVER_IP=$(terraform output -json teleport_public_ip | jq -r '."my-server"')

until ssh terraform@${SERVER_IP} sudo cat /root/teleport-admin;do 
sleep 1
done

REGISTRATION_URL=$(ssh terraform@${SERVER_IP} sudo cat /root/teleport-admin | awk '/web/{print $1}')

TOKEN=$(basename $REGISTRATION_URL)

echo $TOKEN

echo "visit this URL to set a password:"
echo https://$(terraform output -json teleport_dns  | jq -r '."my-server"')/web/invite/$TOKEN

open https://$(terraform output -json teleport_dns  | jq -r '."my-server"')/web/invite/$TOKEN

tsh login --proxy=$(terraform output -json teleport_dns  | jq -r '."my-server"'):443 --user=teleport-admin

echo "Generating token..."

JOIN_TOKEN=$(tctl tokens add --type=node --format json | jq -r .token)
echo "Token generated, use this to join nodes: $JOIN_TOKEN"
