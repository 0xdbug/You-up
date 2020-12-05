//
//  Tweak.x
//  youup
//
//  Created by 1di4r on 4/16/20.
//  Copyright © 2020 1di4r. All rights reserved.
//

#import "Youup.h"

%group youup
%hook CSFullscreenNotificationViewController


-(void)loadView{
	%orig;

	// You up - Custom UIView:
	[YPView removeFromSuperview];
	numberOfTries = 0;
	YPView = [[UIView alloc] initWithFrame:CGRectMake(
		0,
		0,
		[[UIScreen mainScreen] bounds].size.width,
		[[UIScreen mainScreen] bounds].size.height
	)];
	[self.view addSubview:YPView];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
	[YPView addGestureRecognizer:tap];

	// BlurEffect:
	if (!CC){
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
	if (!CC){
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

	if ([randomS isEqual: @"-"]){
		if (randomNumberA < randomNumberB){
			x = (randomNumberB - randomNumberA);
			NSInteger temp = randomNumberB;
			randomNumberB = randomNumberA;
			randomNumberA = temp;
		}else{
			x = (randomNumberA - randomNumberB);
		}
	}
	else if ([randomS isEqual: @"+"]){
		x = (randomNumberA + randomNumberB);
	}
	else if ([randomS isEqual: @"*"]){
		x = (randomNumberA * randomNumberB);
	}
	else if ([randomS isEqual:@"/"]) {
		if (randomNumberB == 0) randomNumberB = 1 + arc4random_uniform(Range);
		randomNumberA *= randomNumberB;
		x = (randomNumberA / randomNumberB);
	}

	NSString *Equation = [NSString stringWithFormat: @"%ld %@ %ld = ?", randomNumberA, randomS, randomNumberB];

	// DEBUG:
/*	UILabel *qLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		qLabel.font = [UIFont systemFontOfSize:25];
		qLabel.textColor = [UIColor whiteColor];
		qLabel.numberOfLines = 0; //will wrap text in new line
		qLabel.textAlignment = NSTextAlignmentCenter;
		[qLabel setCenter:CGPointMake(self.view.center.x, 245)];
	//[qLabel setText:[NSString stringWithFormat: @"%@", Equation]];
	[qLabel setText:[NSString stringWithFormat: @"%@", BGS]]; 

	[YPView addSubview:qLabel];
	[qLabel sizeToFit];	 */

	// TextField:
	YPField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 295.0, 38.0)];
		
	//	[YPField setPlaceholder: [NSString stringWithFormat: @"%@", Equation]];
	YPField.layer.cornerRadius = 8;
	YPField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	YPField.textAlignment = NSTextAlignmentCenter;

	//  https://developer.apple.com/documentation/uikit/uitextfield/1619610-attributedplaceholder?language=objc
	UIColor *placeholderColor = [UIColor whiteColor];
	YPField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @"%@", Equation] attributes:@{NSForegroundColorAttributeName: placeholderColor}];
	if (!CC){
		
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
	[checkButton addTarget:self action:@selector(Check)
		forControlEvents:UIControlEventTouchUpInside];
	[checkButton setTitle:@"Done" forState:UIControlStateNormal];
	if(!CC){
		[checkButton setBackgroundColor: [[UIColor clearColor] colorWithAlphaComponent:0.5]];
	}else{
		UIColor *selectedBTN = LCPParseColorString(BTNS, @"#ffffff");
		[checkButton setBackgroundColor: selectedBTN];
	}
	[checkButton setCenter:CGPointMake(self.view.center.x, 445)];
	checkButton.layer.cornerRadius = 12;
	[YPView addSubview:checkButton];


}

// In case they didnt disable buttons

-(void)lockButtonPressed:(id)arg1 {

//		NSLog(@"Youup - LockButton %@", arg1);

		YPField.transform = CGAffineTransformMakeTranslation(20, 0);
		[UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		YPField.transform = CGAffineTransformIdentity;
		} completion:nil];
 
}

-(void)volumeChanged:(id)arg1 {

//	  	NSLog(@"Youup - VolumeButton %@", arg1);

		YPField.transform = CGAffineTransformMakeTranslation(20, 0);
		[UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		YPField.transform = CGAffineTransformIdentity;
		} completion:nil];
}


%new
-(void)Check{
	 if (numberOfTries >= SAttempt){
		[self showSkipBTN];
	}

	if ([NSString stringWithFormat: @"%ld", (long)x] == YPField.text){
	[UIView animateWithDuration:0.2
		 animations:^{YPView.alpha = 0.0;}
		 completion:^(BOOL finished){ [YPView removeFromSuperview]; 
	}];
	}else{
		if ([YPField hasText]) numberOfTries++;

		YPField.transform = CGAffineTransformMakeTranslation(20, 0);
		[UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		YPField.transform = CGAffineTransformIdentity;
		} completion:nil];
	}
}

%new
-(void)showSkipBTN{

		UIButton *skipButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 240.0, 50.0)];
		[skipButton addTarget:self action:@selector(Skip)
		 forControlEvents:UIControlEventTouchUpInside];
		[skipButton setTitle:@"Skip" forState:UIControlStateNormal];
		if(!CC){
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
-(void)Skip{
	[UIView animateWithDuration:0.2
		 animations:^{YPView.alpha = 0.0;}
		 completion:^(BOOL finished){ [YPView removeFromSuperview]; 
	}];
}

%new
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

%new
-(void)dismissKeyboard {
	[YPField resignFirstResponder];
}
%end 

 

/*
   * AutoUnlockX compatibility
*/

%hook SparkAutoUnlockX
-(BOOL)externalBlocksUnlock {
	if (YPView.superview) return TRUE;
	return %orig;
}
%end

/*
   * Rofi compatibility
*/

%hook RFViewController
-(id)view{
	if (YPView.superview) return nil;
	return %orig;
}
%end
%end

 
%group DisableSiri

%hook SBHomeHardwareButton
- (void)longPress:(id)arg1 {
    if (YPView.superview) arg1 = NULL;
    %orig;
} 
%end
%hook SBLockHardwareButton
- (void)longPress:(id)arg1{
	if (YPView.superview) arg1 = NULL;
    %orig;
			
}
%end 

%end


%group DisableButtons

%hook SBLockHardwareButton
-(void)singlePress:(id)arg1{
	if (YPView.superview){
		// Do nothing.
		}else{
			%orig;
	}
			
}
%end
 

%hook SBVolumeHardwareButton
- (void)volumeIncreasePress:(id)arg1{
	if (YPView.superview){
			// Do nothing.
		}else{
			%orig;
	}
			
}

- (void)volumeDecreasePress:(id)arg1{
	if (YPView.superview){
			// Do nothing.
		}else{
			%orig;
	}
}
%end 

%end
 

static void prefChanged() {
	HBPreferences *prefs = [[HBPreferences alloc] initWithIdentifier:@"cf.1di4r.ypprefs"];
	Enabled = [([prefs objectForKey:@"kEnabled"] ?: @(YES)) boolValue];
	Disablebuttons = [([prefs objectForKey:@"kDisablebuttons"] ?: @(YES)) boolValue];
	DisableSiri = [([prefs objectForKey:@"kDisableSiri"] ?: @(YES)) boolValue];
	Addition = [([prefs objectForKey:@"kAddition"] ?: @(YES)) boolValue];
	Division = [([prefs objectForKey:@"kDivision"] ?: @(YES)) boolValue];
	Subtraction = [([prefs objectForKey:@"kSubtraction"] ?: @(YES)) boolValue];
	Multiplication = [([prefs objectForKey:@"kMultiplication"] ?: @(YES)) boolValue];
	Range = [([prefs objectForKey:@"kRange"] ?: @(5)) intValue];
	CC = [([prefs objectForKey:@"kCC"] ?: @(NO)) boolValue];
	SkipBTNEnabled = [([prefs objectForKey:@"SkipBTNEnabled"] ?: @(NO)) boolValue];
	SAttempt = [([prefs objectForKey:@"SAttempt"] ?: @(5)) intValue];
	
	// For some reasons i cant get the hex value with the code above
	// So i had to create a new Dictionary and then get the hex value
	// Let me know if you know whats the problem ;)

	NSDictionary *prefsDir = [NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/cf.1di4r.ypprefs.plist"];
	BGS = [prefsDir objectForKey: @"kBG"];
	CKS = [prefsDir objectForKey: @"kCK"];
	TFS = [prefsDir objectForKey: @"kTF"];
	BTNS = [prefsDir objectForKey: @"kBTN"];
	
}

%ctor{
	prefChanged();
	if (Enabled){
		%init(youup);
		if (Disablebuttons){
			%init(DisableButtons);
		}
		if (DisableSiri){
			%init(DisableSiri);
		}
	}
}
