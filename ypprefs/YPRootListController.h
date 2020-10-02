#import <Preferences/PSListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <CepheiPrefs/HBRootListController.h>
#import <Cephei/HBRespringController.h>
#import <Cephei/HBPreferences.h>
#import <spawn.h>

@interface YPRootListController : HBRootListController

@end

#define UICOLOR_FROM_RGBA(r,g,b,a) \
	[UIColor \
		colorWithRed:((r) / 255.0) \
		green:((g) / 255.0) \
		blue:((b) / 255.0) \
		alpha:(a) \
	]
#define THEME_COLOR UICOLOR_FROM_RGBA(53.0, 105.0, 85.0, 255.0)
#define NAVBG_COLOR UICOLOR_FROM_RGBA(86.0, 162.0, 135.0, 255.0)