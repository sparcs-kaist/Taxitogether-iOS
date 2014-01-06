//
//  MyTogetherViewController.m
//  TaxiTogether
//
//  Created by Fragarach on 7/24/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import "MyTogetherViewController.h"
#import "MyTogetherCommentViewCell.h"
#import "MyTogetherNewCommentViewController.h"
#import "MyTogetherParticipantsViewController.h"
#import "MyTogetherHeaderViewController.h"
#import "MyTogetherHeaderDescriptionCellController.h"
#import <QuartzCore/QuartzCore.h>

#define COMMENT_CELL_HEIGHT 70.0
#define COMMENT_CELL_CONTENT_HEIGHT 48.0
#define COMMENT_CELL_CONTENT_WIDTH 302.0

#define DESC_CELL_HEIGHT 60.0
#define DESC_CELL_CONTENT_HEIGHT 18.0
#define DESC_CELL_CONTENT_WIDTH 251.0

#define HEADER_HEIGHT 337.0

#define DEFAULT_CELL_CONTENT_WIDTH 175.0
#define DEFAULT_CELL_CONTENT_HEIGHT 40.0

@implementation MyTogetherViewController
@synthesize ProgressView,realHeader;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

-(IBAction)popToRootView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (CGFloat) getLineHeightForData : (NSString*)data
{
    CGSize cell = CGSizeMake(DESC_CELL_CONTENT_WIDTH , 9999);
    
    CGSize newSize = [data
                      sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:cell
                      lineBreakMode:UILineBreakModeWordWrap];
    CGFloat labelHeight= newSize.height ;
    
    if ( labelHeight < DESC_CELL_CONTENT_HEIGHT )
    {
        labelHeight = DESC_CELL_HEIGHT;
    }
    else 
    {
        labelHeight = DESC_CELL_HEIGHT - DESC_CELL_CONTENT_HEIGHT + labelHeight;
        
    }
    //NSLog(@"kukku %f label height", labelHeight);
    return labelHeight ;


}

- (BOOL) selectingForDefaultWithData: (NSString*)data
{
    CGSize cell = CGSizeMake(DEFAULT_CELL_CONTENT_WIDTH , 9999);
    
    CGSize newSize = [data
                      sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:cell
                      lineBreakMode:UILineBreakModeWordWrap];
    
    return newSize.height <= DEFAULT_CELL_CONTENT_HEIGHT;
}

- (void) updateFields
{
    /*
    destination.text = [myTogether objectForKey:@"destination"];
    departure.text = [myTogether objectForKey:@"departure"];
    departuretime.text = [myTogether objectForKey:@"departtime"];
     */
    
    comments = [myTogether objectForKey:@"comment"];
    
    /* For adding comment */
    [commentDict setObject:[myTogether objectForKey:@"id"] forKey:@"together"];
    realHeader.myTogether=myTogether;
    realHeader.ProgressView=ProgressView;
    realHeader.commentTable=self.tableView;
    realHeader.myTogetherView=self.view;
    realHeader.myTogetherViewController = self;
    
    realHeader.participantsStr=@"";
    realHeader.numberOfParticipants = [[myTogether objectForKey:@"participants"]count]; 
    for(int i=0;i<realHeader.numberOfParticipants;i++)
    {
        NSString *gender=[NSString stringWithFormat:@"%@",[[[myTogether objectForKey:@"participants"]objectAtIndex:i]objectForKey:@"gender"]];
        
        if([gender isEqualToString:@"M"])
        {
            realHeader.participantsStr=[realHeader.participantsStr stringByAppendingFormat:@"%@  남\n",[[[myTogether objectForKey:@"participants"]objectAtIndex:i]objectForKey:@"id"]];
        }
        else if([gender isEqualToString:@"F"])
        {
            realHeader.participantsStr=[realHeader.participantsStr stringByAppendingFormat:@"%@  여\n",[[[myTogether objectForKey:@"participants"]objectAtIndex:i]objectForKey:@"id"]];
        }
        
    }

    if ( [[commentDict objectForKey:@"together"]intValue] == 0 )
    {
        aNavigationItem.rightBarButtonItem.enabled = NO;
    }
    else {
        aNavigationItem.rightBarButtonItem.enabled = YES;
    }
    
    CGFloat desc_increased = [self getLineHeightForData:[myTogether objectForKey:@"description"]];
    CGFloat depa_increased = [self getLineHeightForData:[myTogether objectForKey:@"departure"]];
    CGFloat dest_increased = [self getLineHeightForData:[myTogether objectForKey:@"destination"]];
    
    BOOL is_desc_increased = [self selectingForDefaultWithData:[myTogether objectForKey:@"description"]];
    BOOL is_depa_increased = [self selectingForDefaultWithData:[myTogether objectForKey:@"departure"]];
    BOOL is_dest_increased = [self selectingForDefaultWithData:[myTogether objectForKey:@"destination"]];
    
    int count = 3;
    
    if ( is_dest_increased ) {
        dest_increased = 0;
        count--;
    }
    if ( is_depa_increased ) {
        depa_increased = 0;
        count--;
    }
    if ( is_desc_increased ) {
        desc_increased = 0;
        count--;
    }
    
    CGFloat total_increased_height = desc_increased + depa_increased + dest_increased;
    realHeader.depa_increased = depa_increased;
    realHeader.desc_increased = desc_increased;
    realHeader.dest_increased = dest_increased;
    realHeader.increased = total_increased_height;
    
    CGFloat adjust = realHeader.numberOfParticipants* 21;
    if ( count == 3 )
    {
        adjust = 70;
    } 
    else if ( count == 2 )
    {
        adjust = 50;
    }
    else if ( count == 1 )
    {
        adjust = 31;
    }

    if ( is_depa_increased && is_desc_increased && is_dest_increased )
    {
        //NSLog(@"default is selected");        
        realHeader.tableView.frame = CGRectMake(realHeader.tableView.frame.origin.x
                                                , realHeader.tableView.frame.origin.y
                                                , realHeader.tableView.frame.size.width
                                                , HEADER_HEIGHT + 11 +  realHeader.numberOfParticipants* 21
                                                
                                                );
    }
    else
    {
        realHeader.tableView.frame = CGRectMake(realHeader.tableView.frame.origin.x
                                                , realHeader.tableView.frame.origin.y
                                                , realHeader.tableView.frame.size.width
                                                , HEADER_HEIGHT - (DESC_CELL_HEIGHT)*count + total_increased_height + adjust + realHeader.numberOfParticipants* 21
                                                );
         //NSLog(@"table height %f", self.tableView.frame.size.height + total_increased_height + realHeader.numberOfParticipants* 21 + 25);
    }

    //[self.tableView setTableHeaderView:nil];
    realHeader.navigationController=self.navigationController;
    realHeader.tabBarController=self.tabBarController;
    self.tableView.tableHeaderView = realHeader.view;
    [realHeader.tableView reloadData];
}


- (IBAction) refreshMyTogether
{
    BOOL Alert;
    if(self.tabBarController.selectedIndex==1)
    {
        Alert=YES;
    }
    else
    {
        Alert=NO;
    }
    [comments removeAllObjects];
    [self.tableView reloadData];
    isLoading=TRUE;
    //[self popToRootView];
    ProgressView.center=CGPointMake(160, self.tableView.contentOffset.y+190);
    [self.view addSubview:ProgressView];
    [self.tableView setUserInteractionEnabled:FALSE];
    DBHandler *dbHandler=[DBHandler getDBHandler];
    
    [myTogetherRequestDataDict setObject:[dbHandler.userinfo objectForKey:@"userid"] forKey:@"userid"];
    [myTogetherRequestDataDict setObject:[dbHandler.userinfo objectForKey:@"key"] forKey:@"key"];
    if([networkHandler isNetworkReachableWithAlert:Alert]){
        [networkHandler grabURLInBackground:@"grep/get_my_together/" callObject:self requestDict:myTogetherRequestDataDict method:@"POST" alert:NO];
    }
    else 
    {
        [ProgressView removeFromSuperview];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSString *responseString =[request responseString];
    //NSLog(responseString);
    SBJsonParser* json = [SBJsonParser alloc];
	NSDictionary *dataString = [json objectWithString:responseString];
    int errorcode = [[dataString objectForKey:@"errorcode"]intValue];
    if(errorcode==900){
        myTogether=[dataString objectForKey:@"info"];
        [myTogether retain];
        [self updateFields];
        if([[myTogether objectForKey:@"ispassed"]intValue]==0){
            realHeader.quitTogetherButton.enabled=TRUE;
            realHeader.isPassed = 0;
        }
        else if([[myTogether objectForKey:@"ispassed"]intValue]==1){
            realHeader.quitTogetherButton.enabled=FALSE;
            realHeader.isPassed = 1;
        }
        
    }
    else if(errorcode==901)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"(901)개발자에게 문의해주세요" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
        [self.tabBarController setSelectedIndex:0];
    }
    else if(errorcode==902||errorcode==1000){
        myTogether=[dataString objectForKey:@"info"];
        [myTogether retain];
        [self updateFields];
        realHeader.quitTogetherButton.enabled = NO;
        [realHeader.tableView reloadData];
        
        if(self.tabBarController.selectedIndex==1)
        {
        
            [[[[UIAlertView alloc]initWithTitle:nil message:@"아직 한번도 투게더를\n이용하신 적이 없습니다.\n 한번 이용해 보세요~" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
            [self.tabBarController setSelectedIndex:0];
        }
    }
    else if(errorcode==2)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"사용자 DB에 문제가 발생하여 재인증하여야합니다."  delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
       DBHandler* dbHandler=[DBHandler getDBHandler];
       [dbHandler updateUserInfo:@"" withKey:@""];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"checkDBInfo" object:nil];
        
    }
    else
    {
        [[[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"(%@)개발자에게 문의해주세요",[dataString objectForKey:@"errorcode"]] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease ]show];
        realHeader.quitTogetherButton.enabled=FALSE;
    }
    
    //NSLog(@"requestFinished");
    [json release];
    [self.tableView reloadData];
    [self.tableView setUserInteractionEnabled:TRUE];
    isLoading=FALSE;
    [ProgressView removeFromSuperview];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    if ([error code] == ASIRequestTimedOutErrorType && self.tabBarController.selectedIndex == 1 ) {
        // Actions specific to timeout
        [[[[UIAlertView alloc]initWithTitle:@"네트워크 오류" message:@"RequestTimeOut.\n다시 시도해 보세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
        isLoading=FALSE;
       
        
    }
     [ProgressView removeFromSuperview];
    
}

#pragma mark - View lifecycle

-(IBAction)NewCommentWrite{
    //NSLog(@"NewCommentWrite Method called.");
    
    if([networkHandler isNetworkReachableWithAlert:YES]&&!isLoading){
        
        MyTogetherNewCommentViewController *newCommentView =[[MyTogetherNewCommentViewController alloc]init];
        newCommentView.commentData = commentDict;
        newCommentView.isPassed = [[myTogether objectForKey:@"ispassed"]intValue];
        
        [self.navigationController pushViewController:newCommentView animated:YES];
        [newCommentView release];
    }

}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    networkHandler=[NetworkHandler getNetworkHandler];
    
    UIBarButtonItem *RefreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                                                   target:self action:@selector(refreshMyTogether)];
    UIBarButtonItem *CommetButton = [[UIBarButtonItem alloc] initWithTitle:@"새코멘트" style:UIBarButtonItemStyleBordered target:self action:@selector(NewCommentWrite)];
    
    aNavigationItem.leftBarButtonItem = RefreshButton;
    aNavigationItem.rightBarButtonItem = CommetButton;
    [RefreshButton release];
    [CommetButton release];
    
    selectedIndexArray = [[NSMutableArray alloc]init];
    
    myTogetherRequestDataDict=[[NSMutableDictionary alloc] init];
    myTogether = [[NSMutableDictionary alloc] init];
    
    realHeader = [[MyTogetherHeaderViewController alloc]initWithNibName:@"MyTogetherHeaderViewController" bundle:nil];
    //realHeader.view.layer.borderWidth = 100;//r=[UIColor colorWithRed:234 green:220 blue:255 alpha:1].CGColor;
    
    realHeader.increased = -1;
    commentDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"", @"comment", @"0", @"together", nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMyTogether) name:@"applicationWillEnterForeground" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(popToRootView) name:@"MyTogetherViewPopToRoot" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMyTogether) name:@"MyTogetherViewRefresh"
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popToRootView) name:@"MyTogetherViewRefresh" object:nil];
    [self.tableView setTableHeaderView:realHeader.tableView];
    isLoading=FALSE;
    
    [self refreshMyTogether];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [selectedIndexArray release];
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[networkHandler hasTogetherWithDelegate:self];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [comments count];
}

- (CGFloat) getLineHeightForContent:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView
{
    CGSize cell = CGSizeMake(COMMENT_CELL_CONTENT_WIDTH , 9999);
    
    CGSize newSize = [[[comments objectAtIndex:[indexPath row]] objectForKey:@"text"]
                      sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:cell
                      lineBreakMode:UILineBreakModeWordWrap];
    return newSize.height + 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [selectedIndexArray containsObject:indexPath])
    {
        CGFloat newheight = [self getLineHeightForContent:indexPath withTableView:tableView];
        if ( newheight < COMMENT_CELL_CONTENT_HEIGHT){
            return COMMENT_CELL_HEIGHT;
        }
        else {
            //NSLog(@"I AM HERE");
            return COMMENT_CELL_HEIGHT - COMMENT_CELL_CONTENT_HEIGHT + newheight;
        }
    }
    else 
    {
        return COMMENT_CELL_HEIGHT;        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyTogetherCommentCell";
    
    MyTogetherCommentViewCell *cell= (MyTogetherCommentViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        NSArray* nib=[[NSBundle mainBundle] loadNibNamed:@"MyTogetherCommentViewCell" owner:self options:nil];
        cell=(MyTogetherCommentViewCell *)[nib objectAtIndex:0];
    }
    
    cell.writer.font = [UIFont systemFontOfSize:12.0];
    cell.writtentime.font = [UIFont systemFontOfSize:12.0];
    cell.content.font = [UIFont systemFontOfSize:14.0];
    
    if ( [selectedIndexArray containsObject:indexPath] )
    {
        CGFloat labelHeight = [self getLineHeightForContent:indexPath withTableView:tableView];
        if ( labelHeight < cell.content.frame.size.height )
        {
            labelHeight = cell.content.frame.size.height;
        }
        cell.content.frame = CGRectMake(cell.content.frame.origin.x,
                                                 cell.content.frame.origin.y,
                                                 cell.content.frame.size.width,
                                                 labelHeight);
        [cell.content setNumberOfLines:0];
        [cell.content setLineBreakMode:UILineBreakModeWordWrap];
    }
    else {
        cell.content.frame = CGRectMake(cell.content.frame.origin.x,
                                                 cell.content.frame.origin.y,
                                                 cell.content.frame.size.width,
                                                 cell.content.frame.size.height);
        [cell.content setNumberOfLines:0];
        [cell.content setLineBreakMode:UILineBreakModeTailTruncation];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    cell.content.text =[[comments objectAtIndex: [indexPath row]] objectForKey:@"text"];
    cell.writer.text = [[comments objectAtIndex: [indexPath row]] objectForKey:@"id"];
    cell.writtentime.text = [[comments objectAtIndex: [indexPath row]] objectForKey:@"time"];
    cell.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[[[[UIAlertView alloc]initWithTitle:nil message:@"선택했네..!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( [selectedIndexArray containsObject:indexPath]) {
        [selectedIndexArray removeObject:indexPath];
    }
    else {
        [selectedIndexArray addObject:indexPath];
    }
    
    NSArray *paths = [NSArray arrayWithObject :indexPath] ;
    [tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];

}

@end
