//
//  FirstViewController.m
//  hcw_iphone
//
//  Created by Vince Masiello on 7/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFOpenFlowView.h"

@class openFlowViewController;
@class AFOpenFlowView;
@class VMSlider;


@interface FirstViewController : UIViewController {
	
	openFlowViewController	*flowController;
	//VMCard					*anyCard;
	
	NSOperationQueue	*loadImagesOperationQueue;
	
	UISegmentedControl	*iDiff;
	UISegmentedControl	*iAge;
	
	NSNumber *lastSafe;
	NSNumber *lastEff;
	NSNumber *lastDiff;
	NSNumber *lastAge;
	
	NSMutableArray			*finalCardList;
	NSArray			*feelings;
	
	VMSlider *heartSlider;
	VMSlider *umbrellaSlider;
	
	CGPoint		gestureStartPoint;
	CGRect		frameSafe;
	CGRect		frameEff;
	BOOL		withinScope;
	BOOL		arrayExists;
	BOOL		loadCheck;
	NSInteger	whichSpec;
	
	NSMutableDictionary	*VMCardList;
	UIActivityIndicatorView *myIndicator;
	
	NSMutableArray *fullSortList;
	UIControl *optionsView;
	BOOL useIllustrations;
	BOOL useStrictSort;
	BOOL infoOnScreen;
	
	BOOL sortDisabled;
}

@property (nonatomic, retain) openFlowViewController *flowController;
//@property (nonatomic, retain) VMCard *anyCard;
@property (nonatomic, retain) IBOutlet UISegmentedControl *iDiff;
@property (nonatomic, retain) IBOutlet UISegmentedControl *iAge;

@property (nonatomic, retain) NSNumber *lastSafe;
@property (nonatomic, retain) NSNumber *lastEff;
@property (nonatomic, retain) NSNumber *lastDiff;
@property (nonatomic, retain) NSNumber *lastAge;

@property (nonatomic, retain) NSDictionary *cardDictionary;
@property (nonatomic, retain) NSMutableArray *finalCardList;
@property (nonatomic, retain) NSArray *cardTitles;
@property (nonatomic, retain) NSArray *feelings;

//sliders
@property (nonatomic, retain) VMSlider *heartSlider;
@property (nonatomic, retain) VMSlider *umbrellaSlider;

@property BOOL arrayExists;
@property BOOL loadCheck;

@property CGPoint gestureStartPoint;
@property CGRect frameSafe;
@property CGRect frameEff;

@property (nonatomic, retain) NSMutableDictionary *VMCardList;
@property (nonatomic, retain) UIActivityIndicatorView *myIndicator;

//info options menu
@property (nonatomic, retain) NSMutableArray *fullSortList;
@property (nonatomic, retain) UIControl *optionsView;
@property BOOL useIllustrations;
@property BOOL useStrictSort;
@property BOOL infoOnScreen;

@property BOOL sortDisabled;

- (IBAction)segmentChanged:(id)sender;
- (void)updateSearch:(NSString *)whichSpec;
- (void)updateCoverFlow;
- (void)resetNeedsChange;
- (BOOL)shouldRefresh;
//info menu options
- (void)initInfoMenu;
- (void)animateInfo;
- (IBAction)showAllCards;
- (IBAction)switchImageSet;
- (IBAction)toggleStrictSort;
- (IBAction)commitSort:(id)sender;

@end