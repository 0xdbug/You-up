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
	// DEBUG:
	//NSLog(@"PASSED √");

	// You up - Custom View:
	YPView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             0,
                                                             [[UIScreen mainScreen] bounds].size.width,
                                                             [[UIScreen mainScreen] bounds].size.height)];
	[self.view addSubview:YPView];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
	[YPView addGestureRecognizer:tap];

    // BlurEffect:
	if (!kCC){
		UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
			    visualEffectView.frame = YPView.bounds; 
		[YPView addSubview:visualEffectView];
	}else{
    	UIColor *selectedBG = [SparkColourPickerUtils colourWithString: kBGS withFallback: @"#ecf0f1"];
		[YPView setBackgroundColor:selectedBG];
	}

	






	// CurrentTime:
	NSDate *date = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"h:mm"];
	NSString *dateString = [dateFormatter stringFromDate:date];
	UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 60)];
	 	dateLabel.font = [UIFont systemFontOfSize:80];
		if (!kCC){
			dateLabel.textColor = [UIColor whiteColor];
		}else{
			UIColor *selectedCK = [SparkColourPickerUtils colourWithString: kCKS withFallback: @"#bdc3c7"];
			dateLabel.textColor = selectedCK;
		}
		dateLabel.textAlignment = NSTextAlignmentCenter;
		[dateLabel setCenter:CGPointMake(self.view.center.x, 155)];
    [dateLabel setText:dateString];
    [YPView addSubview:dateLabel];
	

	// Setting Up the Equation:
	NSMutableArray *s = [[NSMutableArray alloc]init]; // Symbols
	if (kAddition) {
		[s addObject:@"+"];
	}
	if (kSubtraction){
		[s addObject:@"-"];
	}
	if (kMultiplication){
		[s addObject:@"*"];
	}
	else{
		[s addObjectsFromArray:@[@"+",@"-", @"*"]];
	}
	uint32_t rnd = arc4random_uniform([s count]);
	NSString *randomS = [s objectAtIndex:rnd];

    NSInteger randomNumberA = 0 + arc4random() % (kRange - 0); 
	NSInteger randomNumberB = 0 + arc4random() % (kRange - 0); 

    
    NSString *aNumberString = [NSString stringWithFormat: @"%ld", (long)randomNumberA];
    NSString *bNumberString = [NSString stringWithFormat: @"%ld", (long)randomNumberB];


    if ([randomS isEqual: @"-"]){
		if (randomNumberA < randomNumberB){
   			x = (randomNumberB - randomNumberA);
			aNumberString = [NSString stringWithFormat: @"%ld", (long)randomNumberB];
   			bNumberString = [NSString stringWithFormat: @"%ld", (long)randomNumberA];
		}else{
			x = (randomNumberA - randomNumberB);
		}
    }
    if ([randomS isEqual: @"+"]){
   		x = (randomNumberA + randomNumberB);
    }
    if ([randomS isEqual: @"*"]){
   		x = (randomNumberA * randomNumberB);
    }

	NSString *Equation = [NSString stringWithFormat: @"%@ %@ %@ = ?", aNumberString, randomS, bNumberString];

    // DEBUG:
/*	UILabel *qLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		qLabel.font = [UIFont systemFontOfSize:25];
		qLabel.textColor = [UIColor whiteColor];
		qLabel.numberOfLines = 0; //will wrap text in new line
		qLabel.textAlignment = NSTextAlignmentCenter;
		[qLabel setCenter:CGPointMake(self.view.center.x, 245)];
	//[qLabel setText:[NSString stringWithFormat: @"%@", Equation]];
	[qLabel setText:[NSString stringWithFormat: @"%@", kBGS]]; 

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
		if (!kCC){
    		[YPField setBackgroundColor: [[UIColor clearColor] colorWithAlphaComponent:0.5]];
		}else{
			UIColor *selectedTF = [SparkColourPickerUtils colourWithString: kTFS withFallback: @"#bdc3c7"];
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
		if(!kCC){
	    	[checkButton setBackgroundColor: [[UIColor clearColor] colorWithAlphaComponent:0.5]];
		}else{
			UIColor *selectedBTN = [SparkColourPickerUtils colourWithString: kBTNS withFallback: @"#bdc3c7"];
			[checkButton setBackgroundColor: selectedBTN];
		}
		[checkButton setCenter:CGPointMake(self.view.center.x, 465)];
		checkButton.layer.cornerRadius = 12;
	[YPView addSubview:checkButton];

	// Skip button - NOT RELEASED:

	/* UIButton *skipButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 240.0, 50.0)];
		[skipButton addTarget:self action:@selector(Skip)
 		forControlEvents:UIControlEventTouchUpInside];
		[skipButton setTitle:@"Skip" forState:UIControlStateNormal];
	    [skipButton setBackgroundColor: [[UIColor clearColor] colorWithAlphaComponent:0.5]];
		[skipButton setCenter:CGPointMake(self.view.center.x, 495)];
		skipButton.layer.cornerRadius = 12;
		[skipButton setHidden:YES]; 
	[YPView addSubview:skipButton]; */

	

	
}


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
/*	if (numberOfTries >= 4){
			[skipButton setHidden:NO]; 
	}
*/

// 	https://developer.apple.com/documentation/uikit/uiview/1622515-animatewithduration
	if ([NSString stringWithFormat: @"%ld", (long)x] == YPField.text){
	[UIView animateWithDuration:0.2
     	animations:^{YPView.alpha = 0.0;}
     	completion:^(BOOL finished){ [YPView removeFromSuperview]; 
	}];
	}else{
		//numberOfTries++;

		YPField.transform = CGAffineTransformMakeTranslation(20, 0);
		[UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    	YPField.transform = CGAffineTransformIdentity;
		} completion:nil];
	}
}

/*%new
-(void)Skip{

//	https://developer.apple.com/documentation/uikit/uiview/1622515-animatewithduration
	[UIView animateWithDuration:0.2
 		animations:^{YPView.alpha = 0.0;}
     	completion:^(BOOL finished){ [YPView removeFromSuperview]; 
		}];	
}

*/

%new
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
/*	if (YPField.text != ""){
		[self Check];
	}
 	*/
    return YES;
}

%new
-(void)dismissKeyboard {
    [YPField resignFirstResponder];
}

%end

%end

%group DisableButtons
//MARK: headache
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
    kEnabled = [([prefs objectForKey:@"kEnabled"] ?: @(YES)) boolValue];
    kDisablebuttons = [([prefs objectForKey:@"kDisablebuttons"] ?: @(YES)) boolValue];
	kAddition = [([prefs objectForKey:@"kAddition"] ?: @(YES)) boolValue];
	kSubtraction = [([prefs objectForKey:@"kSubtraction"] ?: @(YES)) boolValue];
	kMultiplication = [([prefs objectForKey:@"kMultiplication"] ?: @(YES)) boolValue];
	kRange = [([prefs objectForKey:@"kRange"] ?: @(5)) intValue];
	kCC = [([prefs objectForKey:@"kCC"] ?: @(NO)) boolValue];
	//kBGS = [prefs objectForKey: @"kBG"];
	
	// For some reasons i cant get the hex value with the code above
	// So i had to create a new Dictionary and then get the hex value
	// Let me know if you know whats the problem ;)

    NSDictionary *prefsDir = [NSDictionary dictionaryWithContentsOfFile: @"/var/mobile/Library/Preferences/cf.1di4r.ypprefs.plist"];
    kBGS = [prefsDir objectForKey: @"kBG"];
	kCKS = [prefsDir objectForKey: @"kCK"];
	kTFS = [prefsDir objectForKey: @"kTF"];
	kBTNS = [prefsDir objectForKey: @"kBTN"];
	
}

%ctor{
	prefChanged();
	if (kEnabled){
		%init(youup);
		if (kDisablebuttons){
			%init(DisableButtons);
		}
	}
}