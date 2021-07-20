// #import <AudioToolbox/AudioServices.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import "libcolorpicker.h"

@interface MTAAlarmEditViewController: UIViewController
@property(strong, nonatomic) UITableView *settingsTable;
@end

@interface CSCoverSheetViewControllerBase : UIViewController
@end

@interface CSModalViewControllerBase : CSCoverSheetViewControllerBase
@end

@interface CSFullscreenNotificationViewController : CSModalViewControllerBase <UITextFieldDelegate>
@property (nonatomic, weak) UIView * YPView;
@property(strong, nonatomic) UIView *viewIfLoaded;
- (void)skip;
- (void)check;
- (void)showSkipBTN;
- (void)_handlePrimaryAction;
@end

@interface SBHomeHardwareButton: NSObject
- (void)disable;
- (void)_createGestureRecognizersWithConfiguration:(id)arg1 ;
@end

@interface SBLockScreenManager : NSObject
- (void)disable;
- (void)enable;
- (void)setBiometricAutoUnlockingDisabled:(BOOL)arg1 forReason:(id)arg2 ;
@end

UIButton * skipButton;
UIView * YPView;
UITextField * YPField;
NSInteger x;
NSInteger numberOfTries = 0;
BOOL Enabled;
BOOL DisableHomeButton;
BOOL DisableSideButtons;
BOOL Addition;
BOOL Subtraction;
BOOL Multiplication;
BOOL Division;
BOOL SkipBTNEnabled;

int Range;
int SAttempt;

BOOL CC;

NSString * BGS = NULL;  // Background hex/string
NSString * CKS = NULL;  // Clock hex/string
NSString * TFS = NULL;  // TextField hex/string
NSString * BTNS = NULL; // Button hex/string
