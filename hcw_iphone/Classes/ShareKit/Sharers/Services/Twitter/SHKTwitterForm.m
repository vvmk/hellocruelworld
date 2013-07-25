//
//  SHKTwitterForm.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/22/10.

//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//

#import "SHKTwitterForm.h"
#import "SHK.h"
#import "SHKTwitter.h"


@implementation SHKTwitterForm

@synthesize delegate;
@synthesize textView;
@synthesize counter;
@synthesize counterLabel;
@synthesize hasAttachment;

@synthesize placeholderText;

- (void)dealloc 
{
	[delegate release];
	[textView release];
	[counter release];
	[counterLabel release];
	
	[placeholderText release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{		
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																							  target:self
																							  action:@selector(cancel)];
		
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet"
																				  style:UIBarButtonItemStyleDone
																				 target:self
																				 action:@selector(save)];
    }
    return self;
}



- (void)loadView 
{
	[super loadView];
	
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 11, 280, 122)];
	textView.delegate = self;
	textView.font = [UIFont systemFontOfSize:15];
	textView.backgroundColor = [UIColor whiteColor];
	textView.scrollEnabled = NO;
	
	UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 122)];
    imgView.image = [UIImage imageNamed: @"textviewbg.png"];
    [textView addSubview: imgView];
    [textView sendSubviewToBack:imgView];
	[imgView release];
	[self.view addSubview:textView];
	[textView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	//set up initial counter/progressbar
	[self updateCounter];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];	
	
	// Remove observers
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name: UIKeyboardWillShowNotification object:nil];
	
	// Remove the SHK view wrapper from the window
	[[SHK currentHelper] viewWasDismissed];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {	
	textView.frame = CGRectMake(20, 11, 280, 122);
	[self layoutCounter];
}

#pragma mark -

- (void)updateCounter
{
	if (counter == nil)
	{
		self.counter = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
		counter.opaque = NO;
		
		[self.view addSubview:counter];
		[self layoutCounter];
		[counter release];
	}
	if (counterLabel == nil) {
		self.counterLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		
		counterLabel.backgroundColor = [UIColor clearColor];
		counterLabel.opaque = NO;
		counterLabel.font = [UIFont boldSystemFontOfSize:10];
		counterLabel.textAlignment = UITextAlignmentRight;
		
		[self.view addSubview:counterLabel];
		[self layoutCounter];
		
		[counterLabel release];

	}
	
	int count = (hasAttachment?115:140) - self.textView.text.length;
	counter.progress = textView.text.length / 140.0f;
	counterLabel.text = [NSString stringWithFormat:@"%i / 140", count];
	counterLabel.font = [UIFont systemFontOfSize:10];
	counterLabel.textColor = count >= 0 ? [UIColor blackColor] : [UIColor redColor];
}

- (void)layoutCounter
{
	counter.frame = CGRectMake(115, 141, 89, 11);
	counterLabel.frame = CGRectMake(134, 140, 45, 12);
	
}

#pragma mark -
#pragma mark TextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	[self updateCounter];
}

- (void)textViewDidChange:(UITextView *)textView
{
	[self updateCounter];	
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	[self updateCounter];
}

/*- (BOOL)textView:(UITextView *)thisTextView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [thisTextView resignFirstResponder];
        return YES;
    }
    return NO;
}*/

#pragma mark -

- (void)cancel
{	
	[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
}

- (void)save
{	
	if (textView.text.length > (hasAttachment?115:140))
	{
		[[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Message is too long")
									 message:SHKLocalizedString(@"Twitter posts can only be 140 characters in length.")
									delegate:nil
						   cancelButtonTitle:SHKLocalizedString(@"Close")
						   otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	else if (textView.text.length == 0)
	{
		[[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Message is empty")
									 message:SHKLocalizedString(@"You must enter a message in order to post.")
									delegate:nil
						   cancelButtonTitle:SHKLocalizedString(@"Close")
						   otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	[(SHKTwitter *)delegate sendForm:self];
	
	[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
}

@end
