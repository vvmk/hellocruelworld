//
//  CloudResultsViewController.h
//  hcw_iphone
//
//  Created by Vince Masiello on 8/5/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CloudResultsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {

	UITableView *cloudResultsView;
	NSArray *listData;
	NSArray *feelings;
}

@property (nonatomic, retain) IBOutlet UITableView *cloudResultsView;
@property (nonatomic, retain) NSArray *listData;
@property (nonatomic, retain) NSArray *feelings;
- (UIColor *)colorForCard:(NSString *)card;
@end
