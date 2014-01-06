//
//  NewTogetherTimeSelectViewConrtoller.m
//  TaxiTogether
//
//  Created by Jay on 11. 7. 1..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "NewTogetherTimeSelectViewConrtoller.h"

@implementation NewTogetherTimeSelectViewConrtoller
@synthesize DatePicker,DataDict;

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
    //UIBarButtonItem *Done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(SelectDone)];
   // self.navigationItem.leftBarButtonItem=Done;
    NSDate *Today = [NSDate date];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:Today];
    
    NSInteger remainder = [dateComponents minute] % 5; // gives us the remainder when divided by 5 (for example, 25 would be 0, but 23 
    Today = [Today dateByAddingTimeInterval:((5 - remainder) * 60)]; // Add the difference
    
    // Subtract the number of seconds
    Today = [Today dateByAddingTimeInterval:(-1 * [dateComponents second])];
    
    DatePicker.date=Today;
    DatePicker.minimumDate=Today;
    DatePicker.maximumDate=[Today dateByAddingTimeInterval:24*3600*6];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)onChange{
    [DataDict setObject:DatePicker.date forKey:@"departtime"];

}
@end
