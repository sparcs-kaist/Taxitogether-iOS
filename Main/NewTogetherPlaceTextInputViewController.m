//
//  NewTogetherPlaceTextInputViewController.m
//  TaxiTogether
//
//  Created by Jay on 11. 7. 3..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "NewTogetherPlaceTextInputViewController.h"

@implementation NewTogetherPlaceTextInputViewController
@synthesize DataDict,TextInput,SelectType;
-(IBAction)Save{
    NSString *testStr=[[[NSString alloc]initWithFormat:@"%@",TextInput.text]autorelease];
    if([testStr isEqualToString:@""])
    {
        if([SelectType isEqualToString:@"Departure"])
            [[[[UIAlertView alloc]initWithTitle:@"오류!" message:@"출발지를 입력하세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease ]show];
        else if([SelectType isEqualToString:@"Destination"])
            [[[[UIAlertView alloc]initWithTitle:@"오류!" message:@"도착지를 입력하세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease ]show];
    }
    else
    {
        if([SelectType isEqualToString:@"Departure"]){
            [DataDict setObject:TextInput.text forKey:@"departure"];
            int count = [self.navigationController.viewControllers count];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:count-3] animated:YES];
        }   
        else if ([SelectType isEqualToString:@"Destination"]){
            [DataDict setObject:TextInput.text forKey:@"destination"];
            int count = [self.navigationController.viewControllers count];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:count-3] animated:YES]; 
        }
    }
}

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
    UIBarButtonItem *btSave=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(Save)];
    self.navigationItem.rightBarButtonItem=btSave;
    [TextInput becomeFirstResponder];
    [btSave release];
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

@end
