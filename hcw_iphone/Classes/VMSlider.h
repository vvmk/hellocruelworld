//
//  VMSlider.h
//  Hello Cruel World
//
//  Created by Vincent Masiello on 11/1/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VMSlider : UIControl {
	NSString		*spec;
	UIImageView		*bgview;
	NSMutableArray	*sections;
	NSMutableArray	*images;
	NSInteger		index;
}
- (void)updateImage:(NSInteger)section;
- (NSInteger)getSection:(CGPoint)touchPoint;

@property (nonatomic, retain) NSString *spec;
@property (nonatomic, retain) UIImageView *bgview;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableArray *images;
@property NSInteger index;
@end
