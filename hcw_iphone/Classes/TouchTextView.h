//
//  TouchTextView.h
//  hcw_iphone
//
//  Created by Vince Masiello on 9/22/10.
//  Copyright 2010 Vincent Masiello All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchTextView : UITextView {
	BOOL shouldRemoveSelf;
}
@property BOOL shouldRemoveSelf;
- (UIViewController*)viewController;
@end
