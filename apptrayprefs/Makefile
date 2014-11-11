SDKVERSION = 8.1
ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = ApptrayPrefs
ApptrayPrefs_FILES = ApptrayPrefs.mm
ApptrayPrefs_INSTALL_PATH = /Library/PreferenceBundles
ApptrayPrefs_FRAMEWORKS = UIKit
ApptrayPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ApptrayPrefs.plist$(ECHO_END)
