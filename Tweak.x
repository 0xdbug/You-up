#import "Youup.h"


%hook CSFullscreenNotificationViewController


- (void)loadView {
    %orig;
    if (Enabled) {
        // You up - Custom UIView:
        [YPView removeFromSuperview];
        numberOfTries = 0;
        YPView = [[UIView alloc] initWithFrame:CGRectMake(0,0,
                                                          [[UIScreen mainScreen] bounds].size.width,
                                                          [[UIScreen mainScreen] bounds].size.height
                                                          )];
        [self.view addSubview:YPView];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"com.1di4r.youup/disable"
         object:self];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        [YPView addGestureRecognizer:tap];

        // BlurEffect:
        if (!CC) {
            UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            visualEffectView.frame = YPView.bounds;
            [YPView addSubview:visualEffectView];
        }else{
            UIColor *selectedBG = LCPParseColorString(BGS, @"#000000");
            [YPView setBackgroundColor:selectedBG];
        }

        // CurrentTime:
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 60)];
        dateLabel.font = [UIFont systemFontOfSize:80];
        if (!CC) {
            dateLabel.textColor = [UIColor whiteColor];
        }else{
            UIColor *selectedCK = LCPParseColorString(CKS, @"#ffffff");
            dateLabel.textColor = selectedCK;
        }
        dateLabel.textAlignment = NSTextAlignmentCenter;
        [dateLabel setCenter:CGPointMake(self.view.center.x, 155)];
        [dateLabel setText:dateString];
        [YPView addSubview:dateLabel];

        // Setting Up the Equation:
        NSMutableArray *s = [NSMutableArray new]; // Symbols

        if (Addition) [s addObject:@"+"];
        if (Subtraction) [s addObject:@"-"];
        if (Multiplication) [s addObject:@"*"];
        if (Division)  [s addObject:@"/"];
        if ([s count] == 0) [s addObjectsFromArray:@[@"+", @"-", @"*", @"/"]];

        uint32_t rnd = arc4random_uniform([s count]);
        NSString *randomS = [s objectAtIndex:rnd];

        NSInteger randomNumberA = arc4random_uniform(Range);
        NSInteger randomNumberB = arc4random_uniform(Range);

        if ([randomS isEqual: @"-"]) {
            if (randomNumberA < randomNumberB) {
                x = (randomNumberB - randomNumberA);
                NSInteger temp = randomNumberB;
                randomNumberB = randomNumberA;
                randomNumberA = temp;
            }else{
                x = (randomNumberA - randomNumberB);
            }
        }
        else if ([randomS isEqual: @"+"]) {
            x = (randomNumberA + randomNumberB);
        }
        else if ([randomS isEqual: @"*"]) {
            x = (randomNumberA * randomNumberB);
        }
        else if ([randomS isEqual:@"/"]) {
            if (randomNumberB == 0) randomNumberB = 1 + arc4random_uniform(Range);
            randomNumberA *= randomNumberB;
            x = (randomNumberA / randomNumberB);
        }

        NSString *Equation = [NSString stringWithFormat: @"%ld %@ %ld = ?", randomNumberA, randomS, randomNumberB];

        // TextField:
        YPField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 295.0, 38.0)];
        YPField.layer.cornerRadius = 8;
        YPField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        YPField.textAlignment = NSTextAlignmentCenter;

        // https://developer.apple.com/documentation/uikit/uitextfield/1619610-attributedplaceholder?language=objc
        UIColor *placeholderColor = [UIColor whiteColor];
        YPField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @"%@", Equation] attributes:@{NSForegroundColorAttributeName: placeholderColor}];
        if (!CC) {
            [YPField setBackgroundColor: [[UIColor clearColor] colorWithAlphaComponent:0.5]];
        }else{
            UIColor *selectedTF = LCPParseColorString(TFS, @"#ffffff");
            [YPField setBackgroundColor: selectedTF];
        }
        [YPField setText: nil];
        YPField.textColor = [UIColor whiteColor];
        [YPField setDelegate:self];
        [YPField setCenter:CGPointMake(self.view.center.x, 325)];
        [YPView addSubview:YPField];

        // Done Button:
        UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 240.0, 50.0)];
        [checkButton addTarget:self action:@selector(check)
              forControlEvents:UIControlEventTouchUpInside];
        [checkButton setTitle:@"Done" forState:UIControlStateNormal];
        if(!CC) {
            [checkButton setBackgroundColor: [[UIColor clearColor] colorWithAlphaComponent:0.5]];
        }else{
            UIColor *selectedBTN = LCPParseColorString(BTNS, @"#ffffff");
            [checkButton setBackgroundColor: selectedBTN];
        }
        [checkButton setCenter:CGPointMake(self.view.center.x, 445)];
        checkButton.layer.cornerRadius = 12;
        [YPView addSubview:checkButton];
    }
}

- (void)lockButtonPressed:(id)arg1 {
    if (Enabled && DisableSideButtons) {
        YPField.transform = CGAffineTransformMakeTranslation(20, 0);
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            YPField.transform = CGAffineTransformIdentity;
        } completion:nil];
    }else{
        %orig;
    }
}

- (void)volumeChanged:(id)arg1 {
    if (Enabled && DisableSideButtons) {
        YPField.transform = CGAffineTransformMakeTranslation(20, 0);
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            YPField.transform = CGAffineTransformIdentity;
        } completion:nil];
    }else{
        %orig;
    }
}

%new
- (void)check {
    if (SkipBTNEnabled && numberOfTries >= SAttempt) {
        [self showSkipBTN];
    }
    if ([NSString stringWithFormat: @"%ld", (long)x] == YPField.text) {
        [UIView animateWithDuration:0.2
                         animations:^{YPView.alpha = 0.0;}
                         completion:^(BOOL finished) { [YPView removeFromSuperview];
        }];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"com.1di4r.youup/enable"
         object:self];
    }else{
        if ([YPField hasText]) numberOfTries++;
        YPField.transform = CGAffineTransformMakeTranslation(20, 0);
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            YPField.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}

%new
- (void)showSkipBTN {
    UIButton *skipButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 240.0, 50.0)];
    [skipButton addTarget:self action:@selector(skip)
         forControlEvents:UIControlEventTouchUpInside];
    [skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    if(!CC) {
        [skipButton setBackgroundColor: [[UIColor clearColor] colorWithAlphaComponent:0.5]];
    }else{
        UIColor *selectedBTN = LCPParseColorString(BTNS, @"#ffffff");
        [skipButton setBackgroundColor: selectedBTN];
    }
    [skipButton setCenter:CGPointMake(self.view.center.x, 445 + 60)];
    skipButton.layer.cornerRadius = 12;
    [YPView addSubview:skipButton];
}
%new
- (void)skip {
    [UIView animateWithDuration:0.2
                     animations:^{YPView.alpha = 0.0;}
                     completion:^(BOOL finished) { [YPView removeFromSuperview];
    }];
}

%new
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

%new
- (void)dismissKeyboard {
    [YPField resignFirstResponder];
}
%end

/*
 * AutoUnlockX compatibility
*/

%hook SparkAutoUnlockX
- (BOOL)externalBlocksUnlock {
    if (YPView.superview) return TRUE;
    return %orig;
}
%end

/*
 * Rofi compatibility
*/

%hook RFViewController
- (id)view {
    if (YPView.superview) return nil;
    return %orig;
}
%end

%hook SBHomeHardwareButton
- (void)longPress:(id)arg1 {
    if (Enabled && DisableHomeButton) {
        if (YPView.superview) arg1 = NULL;
        %orig;
    }else{
        %orig;
    }
}

- (void)_singlePressUp:(id)arg1 {
    if (Enabled && DisableHomeButton) {
        if (YPView.superview) arg1 = NULL;
        %orig;
    }else{
        %orig;
    }
}

- (void)doublePressDown:(id)arg1 {
    if (Enabled && DisableHomeButton) {
        if (YPView.superview) arg1 = NULL;
        %orig;
    }else{
        %orig;
    }
}
%end

/*
	Hey reader! if you are here to learn from the code or just look at it for any reason, i recommend you to read this.

	so, about disabling TouchID.
	There is a "good way" and a "bad way a.k.a kinda good way".

	The "good way" only prevents unlocking, the TouchID is still somewhat active
	which means that there probably is a chance that somehow the user will be able to unlock the phone and dismiss the alarm.

	The "bad way" well, it will disable the TouchID completely which is what we want BUT the reason im not using the "bad way" (and the reason which makes it bad ig)
	is that it only gets called once, and thats when the device is booted (or when you press the lock button? i dont remember tbh) so i have to add a notification observer and
	send a notification whenever the Tweak's view is present, doing that will disable the TouchID BUT it wont be re-enabled by it self
	so i have to send another notf to re-enable TouchID when the Tweaks's view is not present.

	anyways, im using the "good way" so we are...good lol
	but i will keep both just in case


	now why did i write this wall of comment even though im using the "good way", i hear you ask

	yes

*/

// the good way
%hook SBDashBoardBiometricUnlockController
- (BOOL)biometricUnlockBehavior:(id)arg1 requestsUnlock:(id)arg2 withFeedback:(id)arg3 {
	if (Enabled && DisableHomeButton) {
        if (YPView.superview) return NO;
    }
	return %orig;
}
%end

// the bad way (well it depends it can also be good)
// %hook SBLockScreenManager
// - (id)init {
//     [[NSNotificationCenter defaultCenter] addObserver:self
//                                              selector:@selector(disable)
//                                                  name:@"com.1di4r.youup/disable"
//                                                object:nil];
//     [[NSNotificationCenter defaultCenter] addObserver:self
//                                              selector:@selector(enable)
//                                                  name:@"com.1di4r.youup/enable"
//                                                object:nil];
//     return %orig;
// }
// %new
// - (void)disable {
//     // [self setBiometricAutoUnlockingDisabled:TRUE forReason:@"SBApplicationRequestedDeviceUnlock"];
// }
// %new
// - (void)enable {
//     //[self setBiometricAutoUnlockingDisabled:FALSE forReason:@"SBApplicationRequestedDeviceUnlock"];
// }
// - (void)setBiometricAutoUnlockingDisabled:(BOOL)arg1 forReason:(id)arg2 {
//     NSLog(@"[Youup] setBiometricAutoUnlockingDisabled - %d - %@", arg1, arg2);
//     if (Enabled && Disablebuttons) {
//         if (YPView.superview) {
//             NSLog(@"[Youup] setBiometricAutoUnlockingDisabled");
//             %orig(TRUE, arg2);
//         }else{
//             %orig;
//         }
//     }
// }
// %end

%hook SBLockHardwareButton
- (void)longPress:(id)arg1 {
    if (Enabled && DisableSideButtons) {
        if (YPView.superview) arg1 = NULL;
        %orig;
    }else{
        %orig;
    }
}
%end

%hook SBLockHardwareButton
- (void)singlePress:(id)arg1 {
    if (Enabled && DisableSideButtons) {
        if (YPView.superview) {
            // Do nothing.
        }else{
            %orig;
        }
    }else{
        %orig;
    }
}
%end

%hook SBVolumeHardwareButton
- (void)volumeIncreasePress:(id)arg1 {
    if (Enabled && DisableSideButtons) {
        if (YPView.superview) {
            // Do nothing.
        }else{
            %orig;
        }
    }else{
        %orig;
    }
}
- (void)volumeDecreasePress:(id)arg1 {
    if (Enabled && DisableSideButtons) {
        if (YPView.superview) {
            // Do nothing.
        }else{
            %orig;
        }
    }else{
        %orig;
    }
}
%end

// Ringer Switch
%hook SpringBoard
- (void)_updateRingerState:(int)arg1 withVisuals:(BOOL)arg2 updatePreferenceRegister:(BOOL)arg3 {
    if (Enabled && DisableSideButtons) {
        if (YPView.superview) {
            // Do nothing.
        }else{
            %orig;
        }
    }else{
        %orig;
    }
}
%end

static void prefChanged() {
    HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"cf.1di4r.ypprefs"];
    Enabled = [([prefs objectForKey:@"kEnabled"] ?: @(YES)) boolValue];
    DisableSideButtons = [([prefs objectForKey:@"kDisableSideButtons"] ?: @(YES)) boolValue];
    DisableHomeButton = [([prefs objectForKey:@"kDisableHomeButton"] ?: @(YES)) boolValue];
    Addition = [([prefs objectForKey:@"kAddition"] ?: @(YES)) boolValue];
    Division = [([prefs objectForKey:@"kDivision"] ?: @(YES)) boolValue];
    Subtraction = [([prefs objectForKey:@"kSubtraction"] ?: @(YES)) boolValue];
    Multiplication = [([prefs objectForKey:@"kMultiplication"] ?: @(YES)) boolValue];
    Range = [([prefs objectForKey:@"kRange"] ?: @(5)) intValue];
    CC = [([prefs objectForKey:@"kCC"] ?: @(NO)) boolValue];
    SkipBTNEnabled = [([prefs objectForKey:@"SkipBTNEnabled"] ?: @(NO)) boolValue];
    SAttempt = [([prefs objectForKey:@"SAttempt"] ?: @(5)) intValue];

    BGS = [[prefs objectForKey: @"kBG"] stringValue];
    CKS = [[prefs objectForKey: @"kCK"] stringValue];
    TFS = [[prefs objectForKey: @"kTF"] stringValue];
    BTNS = [[prefs objectForKey: @"kBTN"] stringValue];
}

void prefsChanged(
                  CFNotificationCenterRef center,
                  void *observer,
                  CFStringRef name,
                  const void *object,
                  CFDictionaryRef userInfo) {
    prefChanged();
}
%ctor {
    prefChanged();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, prefsChanged, CFSTR("com.1di4r.youup/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
