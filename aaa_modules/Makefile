include $(TOPDIR)/rules.mk

PKG_NAME:=aaa_modules
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_MAINTAINER:=xinyi08042-fafa
PKG_LICENSE:=MIT

include $(INCLUDE_DIR)/package.mk

define Package/mt6000_settings
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=MT6000 reset Settings
  DEPENDS:=
  PKGARCH:=all
endef

define Package/aaa_modules/description
  reset ssid and password
endef

define Build/Compile
endef

define Package/mt6000_settings/install
	$(INSTALL_DIR) $(1)/etc/init.d
        $(INSTALL_BIN) ./files/mt6000-settings.sh $(1)/etc/init.d/mt6000_settings
endef

$(eval $(call BuildPackage,aaa_modules))

