#
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
 
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk
 
PKG_NAME:=gobinetdriver
PKG_RELEASE:=1
 
include $(INCLUDE_DIR)/package.mk
 
define KernelPackage/gobinetdriver
	SUBMENU:=Other modules
	TITLE:=Support Module for YG920 NC5		
	DEPENDS:=+kmod-usb-core kmod-usb-net
	AUTOLOAD:=$(call AutoProbe, gobinetdriver)	
	FILES:=$(PKG_BUILD_DIR)/gobinetdriver.ko
	KCONFIG:=
endef
 
EXTRA_KCONFIG:= \
	CONFIG_GOBINETDRIVER=m 

EXTRA_CFLAGS:= \
	$(patsubst CONFIG_%, -DCONFIG_%=1, $(patsubst %=m,%,$(filter %=m,$(EXTRA_KCONFIG)))) \
	$(patsubst CONFIG_%, -DCONFIG_%=1, $(patsubst %=y,%,$(filter %=y,$(EXTRA_KCONFIG)))) \
 
MAKE_OPTS:= \
        $(KERNEL_MAKE_FLAGS)\
	M="$(PKG_BUILD_DIR)"\
	EXTRA_CFLAGS="$(EXTRA_CFLAGS)" \
	$(EXTRA_KCONFIG)
 
define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef
define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
	$(MAKE_OPTS)  \
		modules
endef
	
$(eval $(call KernelPackage,gobinetdriver))
