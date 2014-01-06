//
//  Together_Auth.m
//  TaxiTogether
//
//  Created by Fragarach on 7/19/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import "Together_Auth.h"
#define kOFFSET_FOR_KEYBOARD 170.0


@implementation Together_Auth
@synthesize authBotton, frontImage, scrollview, userid;
@synthesize keyboardVisible, offset;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [frontImage setImage:[UIImage imageNamed:@"Launching.png"]];
    scrollview.scrollsToTop = NO;
    keyboardVisible = NO;
    userid.enablesReturnKeyAutomatically = TRUE;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [authBotton release];
    [frontImage release];
    [scrollview release];
    [userid release];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard 
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHaveAction:(NSNotification *)notif
{
    //keyboard will be shown now. depending for which textfield is active, move up or move down the view appropriately
    
    if ([userid isFirstResponder] && self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (![userid isFirstResponder] && self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *) textField
{
    [userid resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:userid])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)sender
{
    if ([sender isEqual:userid])
    {
        //move the main view, so that the keyboard does hide it.
        if  (self.view.frame.origin.y < 0)
        {
            [self setViewMovedUp:NO];
        }
    }
}

- (IBAction)backgroundTouch:(id)sender {
    [userid resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHaveAction:) 
                                                 name:UIKeyboardWillShowNotification object:self.view.window]; 
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
} 

@end
