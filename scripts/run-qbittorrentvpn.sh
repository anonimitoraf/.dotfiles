# Get UDP .ovpn file from https://nordvpn.com/ovpn/ and place it into
# /config/openvpn/ inside the docker container

docker run -d \
    --cap-add=NET_ADMIN \
    -p 6881:6881 \
    -p 6881:6881/udp \
    -p 9999:9999 \
    -p 8118:8118 \
    --name=qbittorrentvpn \
    -v /home/anonimito/personal/scripts/qbittorrent-vpn/data:/data \
    -v /home/anonimito/personal/scripts/qbittorrent-vpn:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e VPN_ENABLED=yes \
    -e VPN_PROV=custom \
    -e VPN_CLIENT=openvpn \
    -e STRICT_PORT_FORWARD=yes \
    -e ENABLE_PRIVOXY=no \
    -e LAN_NETWORK=192.168.1.0/24 \
    -e NAME_SERVERS=127.0.0.53,1.0.0.1 \
    -e VPN_INPUT_PORTS=1234 \
    -e VPN_OUTPUT_PORTS=5678 \
    -e DEBUG=true \
    -e WEBUI_PORT=9999 \
    -e UMASK=000 \
    -e PUID=0 \
    -e PGID=0 \
    binhex/arch-qbittorrentvpn
