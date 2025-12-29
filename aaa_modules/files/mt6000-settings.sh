#!/bin/sh
# /etc/uci-defaults/99-mt6000-defaults

[ -f /etc/mt6000-defaults-applied ] && exit 0

# WiFi SSID
echo "Setting WiFi SSID to 'Gl-inet'..."
uci set wireless.default_radio0.ssid='Gl-inet'
uci set wireless.default_radio1.ssid='Gl-inet-5G'
uci commit wireless

# password
echo "Setting password to 'goodlife'..."
PASS_HASH=$(echo -n "$PASSWORD" | openssl passwd -6 -stdin 2>/dev/null)

if [ -n "$PASS_HASH" ]; then
    uci -q delete system.@system[0].password
    uci -q set system.@system[0].passhash="$PASS_HASH"
else
    uci set system.@system[0].password='goodlife'
    echo "root:$(echo 'goodlife' | mkpasswd -m sha-512 -s):0:0:99999:7:::" > /etc/shadow
fi

    uci commit system
    echo "Password set successfully"

#重启网络服务
echo "Restarting network services..."
/etc/init.d/network restart
sleep 3
wifi reload

# 标记已完成
touch /etc/mt6000-defaults-applied
echo "MT6000 default settings applied successfully"

# 删除自身，防止重复执行
rm -f /etc/uci-defaults/99-mt6000-defaults

exit 0
