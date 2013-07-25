//
//  DisplayViewController.h
//  hcw_iphone
//
//  Created by Vince Masiello on 8/9/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchTextView;

@interface DisplayViewController : UIViewController <UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	
	NSString		*cardText;
	NSDictionary	*cardDictionary;
	NSArray			*cardTitles;
	NSString		*currentCard;
	NSArray			*pickerData;
	UIPickerView	*picker;
	UIView			*container;
	
	//top section
	UILabel *uTitle;
	UIImageView *uSafe;
	UIImageView *uEff;
	UIImageView *uDiff;
	UIImageView *uAge;
	UIImageView *topBG;
	UIButton		*mainStar;
}

@property (nonatomic, retain) NSString *cardText;
@property (nonatomic, retain) NSDictionary *cardDictionary;
@property (nonatomic, retain) NSArray *cardTitles;
@property (nonatomic, retain) NSString *currentCard;
@property (nonatomic, retain) NSArray *pickerData;
@property (nonatomic, retain) UIPickerView *picker;
@property (nonatomic, retain) UIView *container;
@property (nonatomic, retain) IBOutlet UIButton *mainStar;

//
@property (nonatomic, retain) IBOutlet UILabel *uTitle;
@property (nonatomic, retain) IBOutlet UIImageView *uSafe;
@property (nonatomic, retain) IBOutlet UIImageView *uEff;
@property (nonatomic, retain) IBOutlet UIImageView *uDiff;
@property (nonatomic, retain) IBOutlet UIImageView *uAge;
@property (nonatomic, retain) IBOutlet UIImageView *topBG;

- (IBAction)navToFeelings:(id)sender;
- (IBAction)starClicked:(id)sender;
- (IBAction)showPicker;
- (void)hidePicker;

@end