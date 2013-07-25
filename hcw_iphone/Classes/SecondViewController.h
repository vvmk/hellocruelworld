//
//  SecondViewController.h
//  hcw_iphone
//
//  Created by Vince Masiello on 8/5/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CloudResultsViewController;

@interface SecondViewController : UIViewController {

	CloudResultsViewController *cloudResultsViewController;
	
	UIView *touchDown;
	
	NSArray *keyResults;
}
@property (nonatomic, retain) CloudResultsViewController *cloudResultsViewController;
@property (nonatomic, retain) UIView *touchDown;
@property (nonatomic, retain) NSArray *keyResults;

- (NSArray *)getResultsForKeyword:(NSString *)keyword;
@end
