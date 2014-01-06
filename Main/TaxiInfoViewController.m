//
//  TaxiInfo.m
//  TaxiTogether
//
//  Created by Jay on 11. 7. 1..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "TaxiInfoViewController.h"

@implementation TaxiInfoViewController
@synthesize background;

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
    taxiPhone = [[NSArray alloc]initWithObjects:
                @"042-867-2000",
                @"042-586-8000",
                @"042-540-8282",
                @"042-333-1000",
                @"042-524-9333",
                nil];
    taxiComp = [[NSArray alloc]initWithObjects:
                @"한밭콜",
                @"양반콜",
                @"한빛콜",
                @"나비콜",
                @"찬양콜",
                nil],
    [background setImage:[UIImage imageNamed:@"calltaxi.png"]];
    isiPhone=[[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] ? 1 : 0;
    selectedButtonIndex = -1;
}

- (void)viewDidUnload
{
    [taxiPhone release];
    [taxiComp release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if ( buttonIndex == 1 ){ // select 통화하기
        NSString *pStr = [[NSString stringWithFormat:@"tel:%@", [taxiPhone objectAtIndex:selectedButtonIndex]]
                          stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pStr]];  
    }
    else {
        return;
    }
    return;
}

- (void)showAlertMessageAt : (int)index {
    
    selectedButtonIndex = index;
    NSString *aMessage = [NSString stringWithFormat:@"%@: %@", 
                           [taxiComp objectAtIndex:selectedButtonIndex], [taxiPhone objectAtIndex:selectedButtonIndex]];

    if(isiPhone)
    {
        [[[[UIAlertView alloc]initWithTitle:@"번호 안내" message:aMessage delegate:self 
                          cancelButtonTitle:@"닫기" otherButtonTitles:@"통화하기", nil]autorelease]show]; 
    }
    else
    {

        [[[[UIAlertView alloc]initWithTitle:@"번호 안내" message:aMessage delegate:nil 
                          cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];         
    }
}

-(IBAction)CallHanBat {
    [self showAlertMessageAt:0];
}

-(IBAction)CallYangBan {
    [self showAlertMessageAt:1];
}

-(IBAction)CallHanBit{
    [self showAlertMessageAt:2];
}

-(IBAction)CallNavi{
    [self showAlertMessageAt:3];
}

-(IBAction)CallChanYang{
    [self showAlertMessageAt:4];
}


@end
