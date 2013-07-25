//
//  ForthViewController.m
//  hcw_iphone
//
//  File Created by Vince Masiello on 7/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ForthViewController.h"
#import "DisplayViewController.h"

@implementation ForthViewController
@synthesize favResultsView;
@synthesize feelings;
@synthesize listData;

- (IBAction)toggleEdit:(id)sender {
	[self.tableView setEditing:!self.tableView.editing animated:YES];
	
	if (self.tableView.editing)
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
	else 
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
}

- (void)viewWillAppear:(BOOL)animated {
	hasFavorites = YES;
	[self setList];
	[self.tableView reloadData];
	self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
	hasFavorites = YES;
	[self setList];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationController.navigationBarHidden = NO;
	self.navigationItem.title = @"Favorites";
	self.navigationItem.backBarButtonItem.title = @"Back";
	UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
																			target:self 
																			action:@selector(toggleEdit:)];
	self.navigationItem.rightBarButtonItem = edit;
	[edit release];
	
	NSArray *array = [[NSArray alloc] initWithArray:[[NSString stringWithContentsOfFile:[[NSBundle mainBundle] 
													  pathForResource:@"feelings" 
													  ofType:@"txt"]
											encoding:NSUTF8StringEncoding
											   error:nil]
				  componentsSeparatedByString:@"\n"]];
	self.feelings = array;
	[array release];
	
	[super viewDidLoad];
}

- (void)setList {
	NSArray *cardTitles = [[NSArray alloc] initWithArray:[[NSString stringWithContentsOfFile:[[NSBundle mainBundle] 
															   pathForResource:@"titles" 
															   ofType:@"txt"] 
													 encoding:NSUTF8StringEncoding
														error:nil]
						   componentsSeparatedByString:@"\n"]];
	NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
	NSMutableArray *tempList = [[NSMutableArray alloc] init];
	for (NSString *card in cardTitles) {
		if ([favorites boolForKey:card])
			[tempList addObject:card];
	}
	self.listData = tempList;
	[tempList release];
	[cardTitles release];
}



#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *DeleteIdentifier = @"DeleteIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 DeleteIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:DeleteIdentifier] autorelease];
	}
	
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [self.listData objectAtIndex:row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.imageView.image = [UIImage imageNamed:@"star.png"];
	cell.textLabel.textColor = [self colorForCard:[listData objectAtIndex:row]];
	
	return cell;
}


#pragma mark -
#pragma mark Table Delegate Methods


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	NSString *rowValue = [self.listData objectAtIndex:row];
	
	DisplayViewController *tempViewController =[[DisplayViewController alloc] 
												initWithNibName:@"DisplayView"
												bundle:nil];
	tempViewController.currentCard = rowValue;
	[self.navigationController pushViewController:tempViewController animated:YES];		
	[tempViewController release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	
	NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
	[favorites setBool:NO forKey:[self.listData objectAtIndex:row]];
	NSString *key = [NSString stringWithFormat:@"%@change",[self.listData objectAtIndex:row]];
	[favorites setBool:YES forKey:key];
	[favorites synchronize];
	[self setList];
	
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[listData release];
	[feelings release];
	[favResultsView release];
    [super dealloc];
}

- (UIColor *)colorForCard:(NSString *)card {
	
	NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
	NSString *key = [NSString stringWithFormat:@"%@feeling",card];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"txt"];
	NSString *contents = [NSString stringWithContentsOfFile:path  encoding:NSUTF8StringEncoding error:nil];
	NSArray *colors = [contents componentsSeparatedByString:@"\n"];
	
	int hexIndex = 0;
	if ([[favorites objectForKey:key] isKindOfClass:[NSString class]])
		hexIndex = [feelings indexOfObject:[favorites objectForKey:key]];
	
	NSString *hex = [colors objectAtIndex:hexIndex];
      
    NSRange range;  
    range.location = 0;  
    range.length = 2;  
    NSString *rString = [hex substringWithRange:range];  
	
    range.location = 2;  
    NSString *gString = [hex substringWithRange:range];  
	
    range.location = 4;  
    NSString *bString = [hex substringWithRange:range];  
	
    unsigned int r, g, b;  
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  
    [[NSScanner scannerWithString:gString] scanHexInt:&g];  
    [[NSScanner scannerWithString:bString] scanHexInt:&b];  
	
    return [UIColor colorWithRed:((float) r / 255.0f)  
                           green:((float) g / 255.0f)  
                            blue:((float) b / 255.0f)  
                           alpha:1.0f];
}

@end
