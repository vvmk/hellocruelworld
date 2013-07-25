//
//  openFlowViewController.h
//  hcw_iphone
//
//  Created by Vince Masiello on 8/2/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFOpenFlowView.h"

@class AFOpenFlowView;
@class VMCard;

@interface openFlowViewController : UIViewController  {
	
	// Queue to hold the cover flow images
	NSOperationQueue			*loadImagesOperationQueue;
	NSMutableArray						*cardList;
	UIActivityIndicatorView		*myIndicator;
	VMCard						*rects;
	
	BOOL						loadAgain;
	BOOL						useIllus;
}

@property (nonatomic, retain) NSArray *cardList;
@property (nonatomic, retain) UIActivityIndicatorView *myIndicator;
@property (nonatomic, retain) VMCard *rects;

@property BOOL loadAgain;
@property BOOL useIllus;

- (void)refresh:(NSMutableArray *)titles cards:(NSMutableDictionary *)allCards;
- (void)backgroundWork:(NSMutableDictionary *)allCards;
- (void)stopSpinner;
- (void)showIndicator;
@end
