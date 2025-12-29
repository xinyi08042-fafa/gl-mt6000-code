#!/bin/sh
# files/set-default-settings.sh

# 只在第一次启动时执行
[ -f /etc/gl-defaults-applied ] && exit 0

uci set wireless.default_radio0.ssid='gl-inet'
uci set wireless.default_radio1.ssid='gl-inet-5G'

uci commit wireless

PASS_HASH="$(echo -n 'goodlife' | openssl passwd -6 -stdin 2>/dev/null)"

if [ -n "$PASS_HASH" ]; then
    # 设置root密码
    uci -q delete system.@system[0].password
    uci -q set system.@system[0].passhash="$PASS_HASH"
    
    # 更新shadow文件
    sed -i "/^root:/c\\root:${PASS_HASH}:0:0:99999:7:::" /etc/shadow
    
    # 提交更改
    uci commit system
    echo "Default password set to: goodlife"
fi

touch /etc/gl-defaults-applied
echo "GL.iNet MT6000 default settings applied successfully"

exit 0
