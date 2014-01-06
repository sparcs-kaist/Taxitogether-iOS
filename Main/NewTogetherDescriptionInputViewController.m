//
//  NewTogetherDescriptionInputController.m
//  TaxiTogether
//
//  Created by 정 창제 on 11. 7. 20..
//  Copyright 2011년 KAIST. All rights reserved.
//

#import "NewTogetherDescriptionInputViewController.h"

@implementation NewTogetherDescriptionInputViewController
@synthesize textView,NewTogetherDataDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [textView becomeFirstResponder];
    [textView setText:[NewTogetherDataDict objectForKey:@"description"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [NewTogetherDataDict setObject:textView.text forKey:@"description"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
