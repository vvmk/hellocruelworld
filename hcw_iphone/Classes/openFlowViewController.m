    //
//  openFlowViewController.m
//  hcw_iphone
//
//  Created by Vince Masiello on 8/2/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import "openFlowViewController.h"
#import "AFOpenFlowView.h"
#import "VMCard.h"


@implementation openFlowViewController
@synthesize cardList;
@synthesize myIndicator;
@synthesize rects;
@synthesize loadAgain;
@synthesize useIllus;

- (void)loadView {
	
	CGRect rect = CGRectMake(0.0f, 20.0f, 320.0f, 300.0f);
	AFOpenFlowView *afo = [[AFOpenFlowView alloc] initWithFrame:rect];
	afo.userInteractionEnabled = YES;
	[self setView:afo];
	[afo release];
	self.loadAgain = NO;
}

-(void)refresh:(NSMutableArray *)titles cards:(NSMutableDictionary *)allCards {
	
	self.cardList = titles;
	if (loadAgain) {
		//[self.view removeFromSuperview];
		self.view == nil;
		CGRect rect = CGRectMake(0.0f, 20.0f, 320.0f, 300.0f);
		AFOpenFlowView *afo = [[AFOpenFlowView alloc] initWithFrame:rect];
		afo.userInteractionEnabled = YES;
		[self setView:afo];
		[afo release];
	}
	self.loadAgain = YES;
	
	[self.view setUserInteractionEnabled:NO];
	
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	CGFloat width = keyWindow.bounds.size.width/4.5;
	CGRect centeredFrame = CGRectMake(round(keyWindow.bounds.size.width/2 - width/2),
									  round(keyWindow.bounds.size.height/3.2 - width/2),
									  width,
									  width);
	
	self.myIndicator = [[UIActivityIndicatorView alloc] initWithFrame:centeredFrame];
	myIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	myIndicator.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
	myIndicator.opaque = NO;
	myIndicator.layer.cornerRadius = 10;
	myIndicator.userInteractionEnabled = NO;
	[self.view addSubview:myIndicator];
	[self.view bringSubviewToFront:myIndicator];
	[myIndicator startAnimating];
	
	[self performSelectorInBackground:@selector(backgroundWork:) withObject:allCards];
}

//-----------------------------THE THREAD WORK--------------------------------


-(void)backgroundWork:(NSMutableDictionary *)allCards {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	assert(pool != nil);
	
	for (int i=0; i < [cardList count]; i++) {
		NSAutoreleasePool *innerPool = [[NSAutoreleasePool alloc] init];
		assert(pool != nil);
		
		VMCard *theCard = (VMCard *)[allCards objectForKey:[cardList objectAtIndex:i]];
		[theCard getUpdatedImage];
		//NSLog(@"after getUpdatedImage - %d", i);
		if (useIllus) {
			[(AFOpenFlowView *)self.view setImage:theCard.illus withTitle:theCard.title forIndex:i];
		} else {
			[(AFOpenFlowView *)self.view setImage:theCard.prev withTitle:theCard.title forIndex:i];
		}
		[innerPool drain];
	}
	//NSLog(@"end coverflow");
	[(AFOpenFlowView *)self.view setNumberOfImages:[cardList count]];	
	[self performSelectorOnMainThread:@selector(stopSpinner)withObject:nil waitUntilDone:NO];
	
	[pool drain];
}

- (void)showIndicator {
	[self.view bringSubviewToFront:myIndicator];
}

- (void)stopSpinner {
    [self.view setUserInteractionEnabled:YES];
    [myIndicator stopAnimating];
    [myIndicator release];
    self.myIndicator = nil;
}	

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
	
    [super didReceiveMemoryWarning];
    //NSLog(@"mem warning openFlowViewController");
    // Release any cached data, images, etc that aren't in use.
	
}

- (void)viewDidDisappear:(BOOL)animated {
	//self.view = nil;
}

- (void)viewDidUnload {
	self.view=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[myIndicator release];
	[cardList release];
	[loadImagesOperationQueue release];
	[rects release];
    [super dealloc];
}

#pragma mark Delegate Protocols

// delegate protocol to tell which image is selected
- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index {
	
	//NSLog(@"%d is selected",index);
	
}

// setting the image 1 as the default pic
- (UIImage *)defaultImage {
	NSString *path = [NSString stringWithFormat:@"%@/trans.png",[[NSBundle mainBundle] resourcePath]];
	return [UIImage imageWithContentsOfFile:path];
}

@end
