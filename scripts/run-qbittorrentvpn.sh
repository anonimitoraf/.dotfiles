# Get UDP .ovpn file from https://nordvpn.com/ovpn/ and place it into
# inside a new folder ./scripts/qbittorrent-vpn/openvpn
#
# Get the username password from https://my.nordaccount.com/dashboard/nordvpn/manual-configuration/service-credentials/
# then paste them into `./qbittorrent-vpn/openvpn/auth.txt`
# Format:
# username
# password

#
# Note: you'll have to change (in the .ovpn file):
# auth-user-pass -> auth-user-pass /config/openvpn/auth.txt
#
# For the web UI password (see https://github.com/binhex/arch-qbittorrentvpn/issues/213#issuecomment-1933317197)
# add this to ./scripts/qbittorrent-vpn/qBittorrent/config/qBittorrent.conf
# [Preferences]
# WebUI\User=admin
# WebUI\Password_PBKDF2="@ByteArray(EFt1EXdMP1pvwWU5AxgL7w==:9nNYQh9Ta8R/aP0qGu7b7yH4NgAQ50qsFPisN1bvaXJS6lZ+vilx70B6O/DHf2l2HFEmi9EqASiS+U7umMdRJA==)"
# then restart the container. This sets the password to adminadmin

docker run -d \
    --cap-add=NET_ADMIN \
    -p 6881:6881 \
    -p 6881:6881/udp \
    -p 9999:9999 \
    -p 8118:8118 \
    --restart always \
    --name=qbittorrentvpn \
    --cap-add=NET_ADMIN \
    --device=/dev/net/tun \
    -v /home/anonimito/.dotfiles/scripts/qbittorrent-vpn/data:/data \
    -v /home/anonimito/.dotfiles/scripts/qbittorrent-vpn:/config \
    -v /mnt/8tb/torrents:/config/qBittorrent/downloads \
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
