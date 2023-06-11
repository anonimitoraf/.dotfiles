if nordvpn status | grep -q -i "status: connected"; then
    echo '<span foreground="green">VPN</span>'
else
    echo '<span foreground="red">No VPN</span>'
fi
