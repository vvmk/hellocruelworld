/**
 * Copyright (c) 2009 Alex Fajkowski, Apparent Logic LLC
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 *
 *
 *changes by: Vincent Masiello Copyright (c) 2010
 *
 */
#import "AFItemView.h"
#import <QuartzCore/QuartzCore.h>
#import "AFOpenFlowConstants.h"
#import "openFlowViewController.h"
#import "AFUIImageReflection.h"


@implementation AFItemView
@synthesize number, imageView, horizontalPosition, verticalPosition;

const static CGFloat kReflectionFraction = 0.20;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.opaque = YES;
		self.backgroundColor = NULL;
		verticalPosition = 0;
		horizontalPosition = 0;
		
		// Image View
		imageView = [[UIImageView alloc] initWithFrame:frame];
		imageView.opaque = YES;
		[self addSubview:imageView];
	}
	
	return self;
}

- (void)setImage:(UIImage *)newImage originalImageHeight:(CGFloat)imageHeight reflectionFraction:(CGFloat)reflectionFraction withTitle:(NSString *)cardTitle {
	[imageView setImage:newImage];
	verticalPosition = 220.0f * reflectionFraction / 2;
	originalImageHeight = 220.0f;
	//TODO:screen scale hack - better remedy in v1.1
	//CGFloat ss = [[UIScreen mainScreen] scale];
	//NSLog(@"%f",newImage.size.height);
	if (newImage.size.width == 320) {
		self.frame = CGRectMake(0, 0, newImage.size.width/2, newImage.size.height/2);
	} else {
		self.frame = CGRectMake(0, 0, newImage.size.width, newImage.size.height);
	}
}

- (void)setNumber:(int)newNumber {
	horizontalPosition = COVER_SPACING * newNumber;
	number = newNumber;
}

- (CGSize)calculateNewSize:(CGSize)baseImageSize boundingBox:(CGSize)boundingBox {
	CGFloat boundingRatio = boundingBox.width / boundingBox.height;
	CGFloat originalImageRatio = baseImageSize.width / baseImageSize.height;
	
	CGFloat newWidth;
	CGFloat newHeight;
	if (originalImageRatio > boundingRatio) {
		newWidth = boundingBox.width;
		newHeight = boundingBox.width * baseImageSize.height / baseImageSize.width;
	} else {
		newHeight = boundingBox.height;
		newWidth = boundingBox.height * baseImageSize.width / baseImageSize.height;
	}
	
	return CGSizeMake(newWidth, newHeight);
}

- (void)setFrame:(CGRect)newFrame {
	[super setFrame:newFrame];
	[imageView setFrame:newFrame];
}

- (void)dealloc {
	[imageView release];
	[super dealloc];
}

@end