#include "YPRootListController.h"


@implementation YPRootListController

- (void)viewDidLoad {
	[super viewDidLoad];

	if (@available(iOS 11, *)) {
		self.navigationController.navigationBar.prefersLargeTitles = false;
		self.navigationController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if (@available(iOS 11, *)) {
		self.navigationController.navigationBar.prefersLargeTitles = false;
		self.navigationController.navigationItem.largeTitleDisplayMode =
			UINavigationItemLargeTitleDisplayModeNever;
	}
}

- (instancetype)init {
	self = [super init];

	if (self) {
		HBAppearanceSettings * appearanceSettings =
			[[HBAppearanceSettings alloc] init];
		//appearanceSettings.largeTitleStyle = HBAppearanceSettingsLargeTitleStyleNever;
		appearanceSettings.tableViewCellSeparatorColor = [UIColor clearColor];
		// appearanceSettings.navigationBarTintColor = THEME_COLOR;
		// appearanceSettings.navigationBarTitleColor = THEME_COLOR;
		// appearanceSettings.statusBarTintColor = [UIColor whiteColor];
		appearanceSettings.tintColor = THEME_COLOR;
		// appearanceSettings.navigationBarBackgroundColor = NAVBG_COLOR;
		self.hb_appearanceSettings = appearanceSettings;
	}
	return self;
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}
- (void)respring {
	/*pid_t pid;
	 * const char* args[] = {"killall", "backboardd", NULL};
	 * posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL); */
	[HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=You%20up%3F"]];
}

@end