//
//  SettingsViewHelpWebView.m
//  TaxiTogether
//
//  Created by 정 창제 on 11. 8. 14..
//  Copyright (c) 2011년 KAIST. All rights reserved.
//

#import "SettingsViewHelpWebView.h"

#define HELP_PAGE @"http://taxi.kaist.ac.kr/help"

@implementation SettingsViewHelpWebView
@synthesize webView,doneButton,navItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        headActivity=[[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]autorelease];
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
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:HELP_PAGE]]];
    webView.scalesPageToFit=YES;
    navItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithCustomView:headActivity]autorelease];
    
    UIBarButtonItem *rightDoneButton=[[[UIBarButtonItem alloc]initWithTitle:@"닫기" style:UIBarButtonItemStyleBordered target:self action:@selector(pushDownModalView)] autorelease];
    navItem.rightBarButtonItem=rightDoneButton;
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

#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    headActivity.hidden=NO;
    [headActivity startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [headActivity stopAnimating];
    headActivity.hidden=YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [headActivity stopAnimating];
    headActivity.hidden=YES;
}

-(IBAction)pushDownModalView
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
