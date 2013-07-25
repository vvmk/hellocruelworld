//
//  VMCard.m
//  hcw_iphone
//
//  Created by Vince Masiello on 9/23/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "VMCard.h"

@implementation VMCard
@synthesize title;
@synthesize index;
@synthesize meta;
@synthesize feeling;
@synthesize hasFeeling;
@synthesize isFavorite;
@synthesize cardTitles;
@synthesize listFeelings;

@synthesize illus;
@synthesize prev;

@synthesize useIllustration;

//possibly set to perform in background
- (void)setupCardForIndex:(NSInteger)i {
	self.index = i;
	
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *plistPath = [bundle pathForResource:@"Alternatives3" ofType:@"plist"];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	
	self.cardTitles = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] 
													pathForResource:@"titles" 
													ofType:@"txt"] 
										  encoding:NSUTF8StringEncoding
											 error:nil]
				componentsSeparatedByString:@"\n"];
	
	self.listFeelings = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] 
													pathForResource:@"feelings" 
													ofType:@"txt"] 
										  encoding:NSUTF8StringEncoding
											 error:nil]
				componentsSeparatedByString:@"\n"];
	
	self.title = [NSString stringWithFormat:@"%@", [cardTitles objectAtIndex:index]];
	self.meta = [dict objectForKey:title];
	
	NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
	NSString *key = [NSString stringWithFormat:@"%@feeling",title];
	if ([[favorites objectForKey:key] isKindOfClass:[NSString class]]) {
		if (![[favorites objectForKey:key] isEqualToString:@"---"]) {
			self.hasFeeling = YES;
			self.feeling = [favorites objectForKey:key];
		}
	} else {
		self.hasFeeling = NO;
		self.feeling = nil;
	}
	
	isFavorite = [favorites boolForKey:title];
	
	[self makeImage];
}

- (id)initWithIndex:(NSInteger)i {
	self = [super init];
    if (self) {
		self.meta = [[NSArray alloc] init];
		self.feeling = [[NSString alloc] init];
		
		[self setupCardForIndex:i];
	}
    return self;
}

- (CGRect)dbl:(CGRect)rect {
		
	//return single * [[UIScreen mainScreen] scale];
	CGFloat xx = rect.origin.x;
		CGFloat xy = rect.origin.y;
		CGFloat xw = rect.size.width * [[UIScreen mainScreen] scale];
		CGFloat xh = rect.size.height * [[UIScreen mainScreen] scale];
		CGRect newRect = CGRectMake(xx,xy,xw,xh);
		return newRect;
}


- (BOOL)isFavorite {
	NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
	return [favorites boolForKey:title];
}

- (BOOL)hasFeeling {
	NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
	NSString *str = [NSString stringWithFormat:@"%@feeling",title];
	if ([[favorites objectForKey:str] isKindOfClass:[NSString class]]) {
		self.feeling = [favorites objectForKey:str];
		return YES;
	} else {
		return NO;
	}
}

- (void)dealloc {
	[title release];
	[meta release];
	[feeling release];
	
	[illus release];
	[prev release];
	
	[cardTitles release];
	[listFeelings release];
	[super dealloc];
}

- (void)getUpdatedImage {
	if ([self needsChange]) {
		NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
		NSString *key = [NSString stringWithFormat:@"%@feeling",title];
		if ([[favorites objectForKey:key] isKindOfClass:[NSString class]]) {
			self.hasFeeling = YES;
			self.feeling = [favorites objectForKey:key];
		} else {
			self.hasFeeling = NO;
			self.feeling = nil;
		}
		self.isFavorite = [favorites boolForKey:title];
		[self makeImage];
	}
}

- (void)resetNeedsChange {
	
	for (int i=0; i <= 100; i++) {
		NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
		NSString *keystring = [[NSString alloc] initWithFormat:@"%@change",title];
		[favorites setBool:NO forKey:keystring];
		[favorites synchronize];
		[keystring release];
	}
}

- (BOOL)needsChange {
	NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
	NSString *keystring = [NSString stringWithFormat:@"%@change",title];
	return [favorites boolForKey:keystring];
}

- (void)makeImage {
	
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *retMod = [NSString string];
	retMod = ([[UIScreen mainScreen] scale] == 2) ? @"@2x" : @"";
	//load illustration
	NSString *illStr = [NSString stringWithFormat:@"illus%i",index];
	NSString *illPath = [NSString stringWithFormat:@"%@/%@%@.png", 
							 [[NSBundle mainBundle] resourcePath], illStr, retMod];
	
	//load preview
	NSString *preStr = [NSString stringWithFormat:@"prev%i",index];
	NSString *prePath = [NSString stringWithFormat:@"%@/%@%@.png", 
						 [[NSBundle mainBundle] resourcePath], preStr, retMod];
	
	//self.illus.cornerRadius = 6.4*ss;
	//self.prev.cornerRadius = 6.4*ss;
	
	if (hasFeeling || isFavorite) {
		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		//CGFloat ss = [[UIScreen mainScreen] scale];
		CGFloat ss = 2;
		CGRect imgRect = CGRectMake(0.0f, 0.0f, (ss*160.0f), (ss*218.0f));
		CGRect starFrame = CGRectMake((ss*112), (ss*14), (ss*34), (ss*34));
		
		UIImageView *fakeIllus = [[UIImageView alloc] initWithFrame:imgRect];
		fakeIllus.layer.cornerRadius = 6.4*ss;
		fakeIllus.backgroundColor = [UIColor whiteColor];
		fakeIllus.clipsToBounds = YES;
		fakeIllus.image = [UIImage imageWithContentsOfFile:illPath];
		
		//TODO: redundancy is there for a reason, although you may not see it :)
		if (hasFeeling) {
			UIImageView *borderView = [[UIImageView alloc] initWithFrame:imgRect];
			borderView.layer.cornerRadius = 6.4*ss;
			borderView.backgroundColor = [UIColor clearColor];
			
			int num = [listFeelings indexOfObject:feeling] + 1;
			NSString *imgStr = [NSString stringWithFormat:@"thorn_%i%@.png", num, retMod];
			NSString *imgPath = [NSString stringWithFormat:@"%@/%@", 
							 [[NSBundle mainBundle] resourcePath], imgStr];
			
			borderView.image = [UIImage imageWithContentsOfFile:imgPath];
			[fakeIllus addSubview:borderView];
			[borderView release];
			//NSLog(@"feeling?");
			
		}
		
		if (isFavorite) {
			UIImageView *star = [[UIImageView alloc] initWithFrame:starFrame];
			NSString *imgPath = [NSString stringWithFormat:@"%@/star%@.png", 
					   [[NSBundle mainBundle] resourcePath], retMod];
			star.image = [UIImage imageWithContentsOfFile:imgPath];
			star.backgroundColor = [UIColor clearColor];
			[fakeIllus addSubview:star];
			[star release];
		}
		
		UIGraphicsBeginImageContext(fakeIllus.bounds.size);
		[fakeIllus.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIImage *iResult = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		self.illus = iResult;
		
		//make preview img
		UIImageView *fakePrev = [[UIImageView alloc] initWithFrame:imgRect];
		fakePrev.layer.cornerRadius = 6.4*ss;
		fakePrev.backgroundColor = [UIColor whiteColor];
		fakePrev.clipsToBounds = YES;
		fakePrev.image = [UIImage imageWithContentsOfFile:prePath];
		
		//TODO: redundancy is there for a reason, although you may not see it :)
		if (hasFeeling) {
			UIImageView *second = [[UIImageView alloc] initWithFrame:imgRect];
			second.layer.cornerRadius = 6.4*ss;
			second.backgroundColor = [UIColor clearColor];
			
			int num = [listFeelings indexOfObject:feeling] + 1;
			NSString *imgStr = [NSString stringWithFormat:@"thorn_%i%@.png", num, retMod];
			NSString *imgPath = [NSString stringWithFormat:@"%@/%@", 
								 [[NSBundle mainBundle] resourcePath], imgStr];
			
			second.image = [UIImage imageWithContentsOfFile:imgPath];
			[fakePrev addSubview:second];
			[second release];
		}
		
		if (isFavorite) {
			UIImageView *secondStar = [[UIImageView alloc] initWithFrame:starFrame];
			NSString *imgPath = [NSString stringWithFormat:@"%@/star%@.png", 
								 [[NSBundle mainBundle] resourcePath], retMod];
			secondStar.image = [UIImage imageWithContentsOfFile:imgPath];
			secondStar.backgroundColor = [UIColor clearColor];
			[fakePrev addSubview:secondStar];
			[secondStar release];
		}
		
		UIGraphicsBeginImageContext(fakePrev.bounds.size);
		[fakePrev.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIImage *pResult = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		self.prev = pResult;
		
		[fakeIllus release];
		[fakePrev release];
		
		//NSLog(@"yes fav/feel%i",index);
		
		[pool drain];
	} else {
		
		//UIImage *resized = [originalImg imageByScalingAndCroppingForSize:CGSizeMake(64, 59)];
		self.illus = [UIImage imageWithContentsOfFile:illPath];
		self.prev = [UIImage imageWithContentsOfFile:prePath];
	}
	
}
@end
