//
//  FacebookViewController.h
//  hcw_iphone
//
//  Created by Vince Masiello on 9/22/10.
//  Copyright 2010 apollic. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FacebookViewController : UIViewController {
	UIWebView	*shareView;
}
@property (nonatomic, retain) IBOutlet UIWebView *shareView;
@end
