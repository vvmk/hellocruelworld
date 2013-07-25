//
//  VMSlider.m
//  Hello Cruel World
//
//  Created by Vincent Masiello on 11/1/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "VMSlider.h"

#define kNumPoints 34

@implementation VMSlider
@synthesize spec;
@synthesize bgview;
@synthesize index;
@synthesize sections;
@synthesize images;

- (void)updateImage:(NSInteger)section {
	NSString *str = [NSString stringWithFormat:[NSString stringWithFormat:@"%@/%i%@.png", [[NSBundle mainBundle] resourcePath], index, spec]];
	self.bgview.image = [UIImage imageWithContentsOfFile:str];
	//NSLog(@"%@", str);
}

- (NSInteger)getSection:(CGPoint)cP {
	int min = CGRectGetMinX([self bounds]);
	//NSLog(@"min = %i",min);
	int width = CGRectGetWidth([self bounds]);
	//NSLog(@"width = %i", width);
	int a = width / 141;
	//NSLog(@"a = %i", a);
	int d = (width - a) / 4;
	//NSLog(@"d = %i", d);
	//NSLog(@"cP.x = %f", cP.x);
	if ((cP.x > (min+a)) && (cP.x < (min+d+1))) {
		return 1;
	} else if ((cP.x > (min+d)) && (cP.x < (min+(2*d)+1))) {
		return 2;
	} else if ((cP.x > (min+(2*d))) && (cP.x < (min+(3*d)+1))) {
		return 3;
	} else if ((cP.x > (min+(3*d))) /*&& (cP.x < (min+(4*d)+1))*/) {
		return 4;
	} else if (cP.x < (min+a)) {
		if ([spec isEqualToString:@"safe"])
			return 0;
		else 
			return 1;

	}
	
	//NSLog(@"returning index: %i",index);
	return index;
}

#pragma mark -
#pragma mark Touch Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint startPoint = [touch locationInView:self];
	self.index = [self getSection:startPoint];
	//NSLog(@"index=%i", index);
	[self updateImage:index];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint newPoint = [touch locationInView:self];
	self.index = [self getSection:newPoint];
	//NSLog(@"index=%i", index);
	[self updateImage:index];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
#pragma mark Init Methods
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = YES;
		self.opaque = YES;
		UIImageView *imgView = [[UIImageView alloc] initWithFrame:[self bounds]];
		self.bgview = imgView;
		self.bgview.backgroundColor = [UIColor blackColor];
		self.bgview.opaque = YES;
		self.bgview.userInteractionEnabled = NO;
		[self addSubview:bgview];
		[self bringSubviewToFront:bgview];
		[imgView release];
		
		self.sections = [[NSMutableArray alloc] initWithCapacity:5];
		self.index = 4;
    }
    return self;
}

#pragma mark -
#pragma mark Memory Methods
- (void)dealloc {
	[spec release];
	[bgview release];
	[sections release];
	[images release];
    [super dealloc];
}


@end
