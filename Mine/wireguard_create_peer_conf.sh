#!/usr/bin/env bash


ROUTE_ALL_TRAFFIC=0

WG_PATH="$HOME/.wireguard"
WG_NAME_PEER="<PEER_A_NAME>"
WG_PRIVATE_IP_PEER=0.0.0.0/24 # Use a private IP located inside the wg0 subnet of the "server"
WG_LISTEN_PORT_PEER=0000

WG_NAME_SERVER="<PEER_B_NAME>"
WG_PRIVATE_IP_SERVER=0.0.0.0/24
WG_LISTEN_PORT_SERVER=0000
WG_PSK_SERVER=""
WG_PUB_KEY_SERVER=""
WG_DOMAIN_SERVER="<REMOTE_HOSTNAME>"

# Generate a new private key, a new public key, and a new pre-shared key
# Check if directory exists, if not found create it using the mkdir
[ ! -d "$WG_PATH" ] && mkdir -p "$WG_PATH"

$(umask 0077; wg genkey | tee $WG_PATH/$WG_NAME_PEER.key | \
  wg pubkey > $WG_PATH/$WG_NAME_PEER.pub; \
  wg genpsk > $WG_PATH/$WG_NAME_PEER-$WG_NAME_SERVER.psk)

sudo ip link add dev wg0 type wireguard
sudo ip addr add $WG_PRIVATE_IP_PEER dev wg0
sudo wg set wg0 listen-port $WG_LISTEN_PORT_PEER private-key $WG_PATH/$WG_NAME_PEER.key 

if [ "$ROUTE_ALL_TRAFFIC" ] ; then
  sudo wg set wg0 peer $WG_PUB_KEY_SERVER preshared-key \
    $WG_PATH/$WG_NAME_PEER-$WG_NAME_SERVER.psk endpoint $WG_DOMAIN_SERVER:$WG_LISTEN_PORT_SERVER allowed-ips 0.0.0.0/0
else
  sudo wg set wg0 peer $WG_PUB_KEY_SERVER preshared-key \
    $WG_PATH/$WG_NAME_PEER-$WG_NAME_SERVER.psk endpoint $WG_DOMAIN_SERVER:$WG_LISTEN_PORT_SERVER allowed-ips $WG_PRIVATE_IP_SERVER
fi

sudo wg showconf wg0 > /etc/wireguard/wg0.conf

