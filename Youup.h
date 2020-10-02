// #import <AudioToolbox/AudioServices.h>
#import <Cephei/HBPreferences.h>
#import "SparkColourPickerUtils.h"

@interface CSCoverSheetViewControllerBase : UIViewController
@end
@interface CSModalViewControllerBase : CSCoverSheetViewControllerBase

@end
@interface CSFullscreenNotificationViewController : CSModalViewControllerBase <UITextFieldDelegate>
@property (nonatomic, weak) UIView * YPView;
@property(strong, nonatomic) UIView *viewIfLoaded;
- (void)Check;
- (void)_handlePrimaryAction;
@end


UIButton * skipButton;
UIView * YPView;
UITextField * YPField;
NSInteger x;     // Solution
// NSInteger numberOfTries = 0; //
BOOL kEnabled;
BOOL kDisablebuttons;
BOOL kAddition;
BOOL kDivision;
BOOL kSubtraction;
BOOL kMultiplication;

int kRange;

//BOOL shouldLock; //should lock the lockbutton

BOOL kCC;
NSString * kBGS = NULL;    // Background hex/string
NSString * kCKS = NULL;    // Clock hex/string
NSString * kTFS = NULL;    // TextField hex/string
NSString * kBTNS = NULL;    // Button hex/string

