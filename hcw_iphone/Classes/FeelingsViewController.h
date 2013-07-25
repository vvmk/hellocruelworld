//
//  FeelingsViewController.h
//  hcw_iphone
//
//  Created by Vince Masiello on 8/17/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FeelingsViewController : UIViewController <UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	
	UIPickerView	*singlePicker;
	NSArray			*pickerData;
	NSString		*currentCard;
}
@property (nonatomic, retain) IBOutlet UIPickerView	*singlePicker;
@property (nonatomic, retain) NSArray *pickerData;
@property (nonatomic, retain) NSString *currentCard;
- (IBAction)optionsPressed:(id)sender;

@end