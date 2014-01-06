//
//  NewCommentViewController.m
//  TaxiTogether
//
//  Created by Fragarach on 7/25/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import "MyTogetherNewCommentViewController.h"
#import "NetworkHandler.h"
#import "DBHandler.h"
#import "SBJsonParser.h"
#import <QuartzCore/QuartzCore.h> 

@implementation MyTogetherNewCommentViewController
@synthesize commentField, commentData, isPassed;

-(IBAction)popView{
    [commentData setObject:commentField.text forKey:@"comment"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)saveComment {
    if([commentField.text isEqualToString:@""])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(nowResistering==NO)
    {
        NetworkHandler *networkHandler = [NetworkHandler getNetworkHandler];
        DBHandler *dbHandler = [DBHandler getDBHandler];
    
        NSMutableDictionary *requestDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                          commentField.text , @"text",
                                          [commentData objectForKey:@"together"], @"together",
                                          [[dbHandler userinfo] objectForKey:@"userid"], @"userid", 
                                          [[dbHandler userinfo] objectForKey:@"key"], @"key",
                                          nil];
    
        [networkHandler grabURLInBackground:@"comment/add_comment/"
                                 callObject:self 
                                requestDict:requestDict
                                     method:@"POST" alert:YES];
        nowResistering=YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        [requestDict release];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString =[request responseString];
    //NSLog(responseString);
    SBJsonParser* json = [SBJsonParser alloc];
	NSDictionary *dataString = [json objectWithString:responseString];
    [json release];
    int errorcode=[[dataString objectForKey:@"errorcode"]intValue];
    if(errorcode==600){
        [[[[UIAlertView alloc]
           initWithTitle:nil message:@"정상 등록되었습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]
         show];
        
        commentField.text = @"";
        [commentData setObject:commentField.text forKey:@"comment"];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MyTogetherViewRefresh" object:nil];

        
    }
    else if(errorcode==601)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"존재하지 않는 투게더입니다" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
        commentField.text=@"";
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MyTogetherViewRefresh" object:nil];
    }
    else if(errorcode==602)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"당신은 이 투게더에 속해 있지 않습니다" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MyTogetherViewRefresh" object:nil];
    }
    else if(errorcode==603)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"코멘트 내용이 없습니다" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==604)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"(604)개발자에게 문의하세요" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MyTogetherViewRefresh" object:nil];
    }
    else if(errorcode==605)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"(605)개발자에게 문의하세요" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MyTogetherViewRefresh" object:nil];
    }
    else
    {
        [[[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"(%@)개발자에게 문의해주세요",[dataString objectForKey:@"errorcode"]] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease ]show];
    }
    
    nowResistering=NO;
    
}


- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    if ([error code] == ASIRequestTimedOutErrorType && self.tabBarController.selectedIndex == 1) {
        // Actions specific to timeout
        [[[[UIAlertView alloc]initWithTitle:@"네트워크 오류" message:@"RequestTimeOut.\n다시 시도해 보세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];        
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
}

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *btCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(popView)];
    
    UIBarButtonItem *btSave = [[UIBarButtonItem alloc] initWithTitle:@"저장" style:UIBarButtonItemStyleBordered target:self action:@selector(saveComment)];
    
    self.navigationItem.title=@"새코멘트";
    self.navigationItem.leftBarButtonItem=btCancel;
    self.navigationItem.rightBarButtonItem=btSave;
    
    if ( !!!isPassed ){
        [[self commentField] setPlaceholder:@"새코멘트를 입력하세요."];
    }
    else {
        [[self commentField] setPlaceholder:@"출발시간이 지나 다른 참가자들이 코멘트를 확인하지 못할 수 있습니다."];
    }
    
    [btCancel release];
    [btSave release];

    /*
    commentField.layer.cornerRadius = 20;
    commentField.layer.masksToBounds = YES;
    commentField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    commentField.layer.borderWidth = 1.0;
     */

    nowResistering=NO;
    commentField.text = [commentData objectForKey:@"comment"];
    [commentField becomeFirstResponder];
    
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
