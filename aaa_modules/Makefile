include $(TOPDIR)/rules.mk

PKG_NAME:=aaa_modules
PKG_VERSION:=1.0
PKG_RELEASE:=2

PKG_MAINTAINER:=xinyi08042-fafa
PKG_LICENSE:=MIT

include $(INCLUDE_DIR)/package.mk

define Package/aaa_modules
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=MT6000 Default Settings
	DEPENDS:=+openssl-util
	PKGARCH:=all
endef

define Package/aaa_modules/description
	Apply default WiFi SSID and password settings for MT6000 router.
endef

define Build/Compile
	# Nothing to compile
endef

define Package/aaa_modules/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/mt6000-settings.sh $(1)/etc/uci-defaults/99-mt6000-defaults
endef

$(eval $(call BuildPackage,aaa_modules))
EOF
