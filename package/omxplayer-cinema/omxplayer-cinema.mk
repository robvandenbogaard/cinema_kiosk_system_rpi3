################################################################################
#
# omxplayer-cinema
#
################################################################################

OMXPLAYER_CINEMA_VERSION = 73adf4405f515b5007417b1d9167b9d64c652f26
OMXPLAYER_CINEMA_SITE = $(call github,robvandenbogaard,omxplayer,$(OMXPLAYER_CINEMA_VERSION))
OMXPLAYER_CINEMA_LICENSE = GPL-2.0+
OMXPLAYER_CINEMA_LICENSE_FILES = COPYING

OMXPLAYER_CINEMA_DEPENDENCIES = \
	host-pkgconf alsa-lib boost dbus ffmpeg freetype libidn libusb pcre \
	rpi-userland zlib

OMXPLAYER_CINEMA_EXTRA_CFLAGS = \
	-DTARGET_LINUX -DTARGET_POSIX \
	`$(PKG_CONFIG_HOST_BINARY) --cflags bcm_host` \
	`$(PKG_CONFIG_HOST_BINARY) --cflags freetype2` \
	`$(PKG_CONFIG_HOST_BINARY) --cflags dbus-1`

# OMXplayer has support for building in Buildroot, but that
# procedure is, well, tainted. Fix this by forcing the real,
# correct values.
OMXPLAYER_CINEMA_MAKE_ENV = \
	SDKSTAGE=$(STAGING_DIR) \
	$(TARGET_CONFIGURE_OPTS) \
	STRIP=true \
	CFLAGS="$(TARGET_CFLAGS) $(OMXPLAYER_CINEMA_EXTRA_CFLAGS)"

define OMXPLAYER_CINEMA_BUILD_CMDS
	$(OMXPLAYER_CINEMA_MAKE_ENV) $(MAKE) -C $(@D) omxplayer.bin
endef

define OMXPLAYER_CINEMA_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/omxplayer.bin $(TARGET_DIR)/usr/bin/omxplayer-cinema
endef

$(eval $(generic-package))
