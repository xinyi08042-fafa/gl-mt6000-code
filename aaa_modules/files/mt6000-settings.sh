#!/bin/sh

# /etc/uci-defaults/99-mt6000-defaults
# 设置MT6000默认配置

# 检查是否已经应用过设置
[ -f /etc/mt6000-defaults-applied ] && exit 0

# 等待网络和无线服务就绪
sleep 5

echo "Applying MT6000 default settings..."

# 1. 设置WiFi SSID
echo "Setting WiFi SSID to 'Gl-inet'..."
uci set wireless.default_radio0.ssid='Gl-inet'
uci set wireless.default_radio1.ssid='Gl-inet-5G'
uci commit wireless

# 2. 生成密码哈希
echo "Setting password to 'goodlife'..."
PASS_HASH="$(echo -n 'goodlife' | openssl passwd -6 -stdin 2>/dev/null || \
             echo -n 'goodlife' | openssl passwd -1 -stdin 2>/dev/null || \
             echo -n 'goodlife' | mkpasswd -m sha-512 -s 2>/dev/null)"

if [ -n "$PASS_HASH" ]; then
    # 使用 passhash 方式
    uci -q delete system.@system[0].password
    uci -q set system.@system[0].passhash="$PASS_HASH"
    
    # 直接更新shadow文件（更可靠）
    if grep -q "^root:" /etc/shadow; then
        sed -i "/^root:/c\\root:${PASS_HASH}:0:0:99999:7:::" /etc/shadow
    else
        echo "root:${PASS_HASH}:0:0:99999:7:::" >> /etc/shadow
    fi
    
    # 提交系统设置
    uci commit system
    echo "Password set successfully"
else
    echo "Warning: Failed to generate password hash"
    # 尝试使用明文密码作为备选方案
    uci set system.@system[0].password='goodlife'
    uci commit system
fi

# 3. 可选：设置时区和语言
uci set system.@system[0].timezone='CST-8'
uci set system.@system[0].zonename='Asia/Shanghai'
uci commit system

# 4. 重启网络服务使WiFi设置生效
echo "Restarting network services..."
/etc/init.d/network restart
sleep 3
wifi reload

# 标记设置已完成
touch /etc/mt6000-defaults-applied
echo "MT6000 default settings applied successfully"

# 删除自身，防止重复执行
rm -f /etc/uci-defaults/99-mt6000-defaults

exit 0
