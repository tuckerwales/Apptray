GO_EASY_ON_ME = 1
THEOS_DEVICE_IP = 127.0.0.1
SDKVERSION = 8.2
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = Apptray
Apptray_FILES = Tweak.xm ApptrayViewController.xm
Apptray_FRAMEWORKS = UIKit QuartzCore CoreGraphics
Apptray_LIBRARIES = grid

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += apptrayprefs
SUBPROJECTS += grid

include $(THEOS_MAKE_PATH)/aggregate.mk
