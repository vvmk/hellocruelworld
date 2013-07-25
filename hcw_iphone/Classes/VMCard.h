//
//  VMCard.h
//  hcw_iphone
//
//  Created by Vince Masiello on 9/23/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface VMCard : NSObject {
	NSInteger index;
	NSString *title;
	NSArray	 *meta;
	NSString *feeling;
	UIImage *illus;
	UIImage *prev;
	NSArray *cardTitles;
	NSArray *listFeelings;
	BOOL isFavorite;
	BOOL hasFeeling;
	BOOL useIllustration;
}
@property NSInteger index;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSArray *meta;
@property (nonatomic, retain) NSString *feeling;
@property (nonatomic, retain) UIImage *illus;
@property (nonatomic, retain) UIImage *prev;
@property (nonatomic, retain) NSArray *cardTitles;
@property (nonatomic, retain) NSArray *listFeelings;
@property BOOL isFavorite;
@property BOOL hasFeeling;
@property BOOL useIllustration;
- (id)initWithIndex:(NSInteger)index;
- (BOOL)isFavorite;
- (BOOL)hasFeeling;
- (CGRect)dbl:(CGRect)rect;
- (void)resetNeedsChange;
- (BOOL)needsChange;
- (void)getUpdatedImage;
- (void)makeImage;
@end
