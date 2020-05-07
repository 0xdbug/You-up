ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

SYSROOT = $(THEOS)/sdks/iPhoneOS12.1.sdk

BUNDLE_NAME = YPPrefs

YPPrefs_FILES = YPRootListController.m
YPPrefs_INSTALL_PATH = /Library/PreferenceBundles
YPPrefs_FRAMEWORKS = UIKit
YPPrefs_PRIVATE_FRAMEWORKS = Preferences
YPPrefs_LIBRARIES += sparkcolourpicker
YPPrefs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs
YPPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/YPPrefs.plist$(ECHO_END)
