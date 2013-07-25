//
//  TouchTextView.m
//  hcw_iphone
//
//  Created by Vince Masiello on 9/22/10.
//  Copyright 2010 Vincent Masiello All rights reserved.
//

#import "TouchTextView.h"


@implementation TouchTextView
@synthesize shouldRemoveSelf;

#pragma mark Touch Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = [touch tapCount];
	
	if (tapCount == 2) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration: 0.5];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[self viewController].navigationController.view cache:NO];
		
		if (shouldRemoveSelf)
			[[self viewController].view removeFromSuperview];
		else 
			[[self viewController].navigationController popViewControllerAnimated:NO];
		
		[UIView commitAnimations];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
   
}

// get parent ViewController 
- (UIViewController*)viewController {
	for (UIView* next = [self superview]; next; next = next.superview) {
		UIResponder* nextResponder = [next nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController*)nextResponder;
		}
	}
	return nil;
}

@end
