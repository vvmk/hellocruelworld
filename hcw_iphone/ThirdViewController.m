//
//  ThirdViewController.m
//  hcw_iphone
//
//  Created by Vince Masiello on 7/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ThirdViewController.h"


@implementation ThirdViewController
@synthesize twitterSearch;
@synthesize backButton;
@synthesize forwardButton;
@synthesize homeButton;
@synthesize activityButton;


- (void)viewDidLoad {
	twitterSearch.delegate = self;
	[self.twitterSearch loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://search.twitter.com/search?q=%23stayalive&format=iphone"]]];
	//start activity indicator
	
	[super viewDidLoad];
}
	 
- (IBAction)navForward {
	if (twitterSearch.canGoForward)
		[twitterSearch goForward];
}

- (IBAction)navBack {
	if (twitterSearch.canGoBack) {
		[twitterSearch goBack];
		
	}
}

- (IBAction)navHome {
	[self.twitterSearch loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://search.twitter.com/search?q=%23stayalive&format=iphone"]]];
}

- (IBAction)activity:(id)sender {
	if (isLoading)
		[twitterSearch stopLoading];
	else 
		[twitterSearch reload];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	isLoading = YES;
	self.backButton.enabled = NO;
	self.forwardButton.enabled = NO;
	self.homeButton.enabled = NO;
	self.activityButton.image = [UIImage imageNamed:@"11-x.png"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	isLoading = NO;
	self.backButton.enabled = YES;
	self.forwardButton.enabled = YES;
	self.homeButton.enabled = YES;
	self.activityButton.image = [UIImage imageNamed:@"01-refresh.png"];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	//[self.view release];
    //self.view = nil;
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.twitterSearch = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.backButton = nil;
	self.forwardButton = nil;
	self.homeButton = nil;
	self.activityButton = nil;
}


- (void)dealloc {
	[twitterSearch release];
	[backButton release];
	[forwardButton release];
	[homeButton release];
	[activityButton release];
    [super dealloc];
}

@end
