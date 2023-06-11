if nordvpn status | grep -q -i "status: connected"; then
    echo '<span foreground="green">vpn: on</span>'
else
    echo '<span foreground="red">vpn: off</span>'
fi
