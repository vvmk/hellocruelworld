//
//  ForthViewController.h
//  hcw_iphone
//
//  Created by Vince Masiello on 7/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface ForthViewController : UITableViewController  <UITableViewDelegate, UITableViewDataSource> {
	
	UITableView *favResultsView;
	
	NSArray *listData;
	NSArray *feelings;
	BOOL	hasFavorites;
}
@property (nonatomic, retain) NSArray *feelings;
@property (nonatomic, retain) IBOutlet UITableView *favResultsView;
@property (nonatomic, retain) NSArray *listData;
- (IBAction)toggleEdit:(id)sender;
- (void)setList;
- (UIColor *)colorForCard:(NSString *)card;
@end
