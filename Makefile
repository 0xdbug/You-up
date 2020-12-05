ARCHS = arm64 arm64e


INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Youup

Youup_FILES = Tweak.x
Youup_CFLAGS = -fobjc-arc
Youup_LIBRARIES = colorpicker
Youup_EXTRA_FRAMEWORKS += Cephei


include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += ypprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
