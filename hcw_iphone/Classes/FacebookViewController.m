    //
//  FacebookViewController.m
//  hcw_iphone
//
//  Created by Vince Masiello on 9/22/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import "FacebookViewController.h"


@implementation FacebookViewController
@synthesize shareView;

- (void)viewDidLoad {
	[self.shareView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.facebook.com/sharer.php?u=http://hellocruelworld.net&t=Hello+Cruel+World"]]];
    [super viewDidLoad];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[shareView release];
    [super dealloc];
}


@end
