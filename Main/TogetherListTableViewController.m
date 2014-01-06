//
//  TogetherListTableViewController.m
//  TaxiTogether
//
//  Created by Jay on 11. 7. 1..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "TogetherListTableViewController.h"
#import "NewTogetherTableViewController.h"
#import "NetworkHandler.h"
#import "DBHandler.h"
#import "TogetherListTableViewCell.h"
#import "SBJsonParser.h"
#import "MainAppDelegate.h"
#import "DetailTogetherView.h"
#import "Together_Auth_ViewController.h"

#define ellipsis @".."
#define CONTENT_WIDTH 231
#define HALF_CONTENT_WIDTH 115

@implementation TogetherListTableViewController
@synthesize TogetherDataArray;

- (NSString*)stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font withString:(NSString *)str
{
    // Create copy that will be the returned result
    NSMutableString *truncatedString = [[str mutableCopy] autorelease];
    
    // Make sure string is longer than requested width
    if ([str sizeWithFont:font].width > width)
    {
        // Accommodate for ellipsis we'll tack on the end
        width -= [ellipsis sizeWithFont:font].width;
        //NSLog(@" width of ell : %f", [ellipsis sizeWithFont:font].width);
        //width -= 5;
        
        // Get range for last character in string
        NSRange range = {truncatedString.length - 1, 1};
        
        // Loop, deleting characters until string fits within width
        while ([truncatedString sizeWithFont:font].width > width) 
        {
            // Delete character at end
            [truncatedString deleteCharactersInRange:range];
            
            // Move back another character
            range.location--;
        }
        
        // Append ellipsis
        [truncatedString replaceCharactersInRange:range withString:ellipsis];
    }
    
    return truncatedString;
}

-(BOOL)checkDBInfo
{
    DBHandler *dbHandler = [DBHandler getDBHandler];
    if ( [[[dbHandler userinfo] objectForKey:@"userid"] isEqualToString:@""]){
        return NO;
    }
    else 
        return YES;
}

-(IBAction)showAuthPage
{
    auth_page = [[Together_Auth_ViewController alloc] initWithNibName:@"Together_Auth_ViewController" bundle:nil];
    [self presentModalViewController:auth_page animated:YES];
}

-(IBAction)NewTogetherMake{
    //NSLog(@"NewTogetherMake Method called.");
    if([networkHandler isNetworkReachableWithAlert:YES]){
        NewTogetherTableViewController *NewTogetherTableView=[[NewTogetherTableViewController alloc]init];
        [networkHandler hasTogetherWithDelegate:NewTogetherTableView];
        [self.navigationController pushViewController:NewTogetherTableView animated:YES];
        [NewTogetherTableView release];
    }
}
-(IBAction)refreshBTClicked{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self.searchDisplayController.searchResultsTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    if(isLoading!=TRUE)
    {
        [self RefreshListTable];
    }
}

-(void)RefreshListTable{
    //NSLog(@"RefreshListTable Method called.");
    refresh=YES;
    cellcount=0;
    searchcellcount=0;
    isLoading=YES;
    
    DBHandler *dbHandler = [DBHandler getDBHandler];
    NSString *userid=[[dbHandler userinfo] objectForKey:@"userid"];
    NSString *key=[[dbHandler userinfo] objectForKey:@"key"];
    if(![userid isEqualToString:@""] && ![key isEqualToString:@""]&&[networkHandler isNetworkReachableWithAlert:YES])
    {
        NSMutableDictionary *requestDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                          userid, @"userid",
                                          key, @"key",nil];
        
        [networkHandler grabURLInBackground:@"grep/get_together_list/" callObject:self  requestDict: requestDict method:@"POST" alert:NO];
        [requestDict release];
    }
    else
    {
        isLoading=NO;
        pullToRefreshActive=YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"TogetherListRefreshEnded" object:nil];
    }
    
}

- (void) pushdownModalView
{
    //NSLog(@"pushDownModalView");
    DBHandler *dbHandler = [DBHandler getDBHandler];
    //NSLog(@"userid : %@ ;; key : %@", [[dbHandler userinfo] objectForKey:@"userid"], [[dbHandler userinfo] objectForKey:@"key"]);
    if ( !!! [[[dbHandler userinfo] objectForKey:@"userid"] isEqualToString:@""])
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    [self RefreshListTable];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MyTogetherViewRefresh" object:nil];
}

-(IBAction)requestMoreTogetherData{
    //NSLog(@"RequestMoreTogetherData");
    refresh=NO;
    DBHandler *dbHandler = [DBHandler getDBHandler];
    
    NSMutableArray *lastArray=[tableArray objectAtIndex:[tableArray count]-1];
    NSString *urlPath=[NSString stringWithFormat:@"grep/get_together_list/"];
    NSMutableDictionary *requestDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[[lastArray objectAtIndex:[lastArray count]-1]objectForKey:@"id"], @"together",[[lastArray objectAtIndex:[lastArray count]-1]objectForKey:@"departtime"],@"departtime" ,
        [[dbHandler userinfo] objectForKey:@"userid"], @"userid", [[dbHandler userinfo] objectForKey:@"key"], @"key",nil];
    [networkHandler grabURLInBackground:urlPath
                             callObject:self 
                            requestDict:requestDict
                                 method:@"POST" alert:YES];
    [requestDict release];
    UIView *activityIndicatorView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center=CGPointMake(160, 25);
    [activityIndicator startAnimating];
    [activityIndicatorView addSubview:activityIndicator];
    
    if(self.searchDisplayController.active)
    {
        [self.searchDisplayController.searchResultsTableView setTableFooterView:activityIndicatorView];
    }
    else
    {
       [self.tableView setTableFooterView:activityIndicatorView];
    }
    [activityIndicator release];
    [activityIndicatorView release];
}



- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    isLoading=FALSE;

    NSString *responseString =[request responseString];
    //NSLog(responseString);
    SBJsonParser* json = [SBJsonParser alloc];
	NSDictionary *dataString = [json objectWithString:responseString];
    int errorcode = [[dataString objectForKey:@"errorcode"]intValue];
    
    [json release]; 
    
    if(errorcode==700){
        [TogetherDataArray release];
        TogetherDataArray=[dataString objectForKey:@"info"];
        [TogetherDataArray retain];
        [self regroupTogetherDataWithClearing:refresh 
                                  sourceArray:TogetherDataArray 
                                     dayArray:Day 
                                 sectionArray:sectionArray 
                                   tableArray:tableArray];
        if(self.searchDisplayController.active==NO)
        {
            [self.tableView reloadData];
        }
        else
        {
            [self.searchDisplayController.delegate searchDisplayController:self.searchDisplayController shouldReloadTableForSearchScope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
            [self.searchDisplayController.delegate searchDisplayController:self.searchDisplayController shouldReloadTableForSearchString:[self.searchDisplayController.searchBar text]];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
        //NSLog(@"requestFinished");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"TogetherListRefreshEnded" object:nil];
        
        pullToRefreshActive=TRUE;
    }
    else if(errorcode==701)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"(701)잘못된 요청입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==702)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"(702)잘못된 요청입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
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
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:[NSString stringWithFormat:@"(%@)개발자에게 문의해주세요",[dataString objectForKey:@"errorcode"]] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease ]show];
    }
    
    if(self.searchDisplayController.active==NO)
    {
       [self.tableView setTableFooterView:nil];
    }
    else
    {
       [self.searchDisplayController.searchResultsTableView setTableFooterView:nil];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    if ([error code] == ASIRequestTimedOutErrorType && self.tabBarController.selectedIndex == 0 ) {
        // Actions specific to timeout
        [[[[UIAlertView alloc]initWithTitle:@"네트워크 오류" message:@"RequestTimeOut.\n다시 시도해 보세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    isLoading=NO;
    pullToRefreshActive=YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TogetherListRefreshEnded" object:nil];
    if(self.searchDisplayController.active==NO)
    {
        [self.tableView setTableFooterView:nil];
    }
    else
    {
        [self.searchDisplayController.searchResultsTableView setTableFooterView:nil];
    }
    
}

-(void)regroupTogetherDataWithClearing:(BOOL)clear sourceArray:(NSMutableArray *)sourceArr dayArray:(NSMutableArray *)dayArray sectionArray:(NSMutableArray *)sectionArr tableArray:(NSMutableArray *)tableArr
{
    
    NSDate *Today = [[NSDate alloc]init];  
   
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components: NSEraCalendarUnit|NSYearCalendarUnit| NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit fromDate: Today];
    [Today release];
    [comps setHour: 0]; 
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate *TodayStart=[[calendar dateFromComponents:comps]dateByAddingTimeInterval:9*3600];
    
    
    NSUInteger unitFlags = NSDayCalendarUnit;
    if(clear==YES){
        for(int i=0;i<[dayArray count];i++)
        {
            [[dayArray objectAtIndex:i]removeAllObjects];
        }
    }
    [sectionArr removeAllObjects];
    [tableArr removeAllObjects];
        
    
    for(int i=0;i<[sourceArr count];i++){        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *tmpTime=[[dfInputFormat dateFromString:[[sourceArr objectAtIndex:i]objectForKey:@"departtime"]]dateByAddingTimeInterval:9*3600];
        NSDateComponents *components = [gregorian components:unitFlags 
                                                    fromDate:TodayStart
                                                      toDate:tmpTime 
                                                     options:1];
        NSInteger days = [components day];
        for(int n=0;n<[dayArray count];n++)
        {
            if(days==n)
                [[dayArray objectAtIndex:n]addObject:[sourceArr objectAtIndex:i]];
        }
        [gregorian release];
        cellcount++;
    }
    for(int i=0;i<[dayArray count];i++)
    {
        if([[dayArray objectAtIndex:i]count]!=0)
        {
            [tableArr addObject:[dayArray objectAtIndex:i]];
            [sectionArr addObject:[NSNumber numberWithInt:i]];
        }
        
    }

    //NSLog(@"regrouped");
    if(cellcount==0 && self.tabBarController.selectedIndex==0)
    {
        [[[[UIAlertView alloc]initWithTitle:nil message:@"투게더가 없습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    // Custom initialization
    return self;
}
- (void) handleEnterForeground: (NSNotification*) sender
{
    //Do whatever you need to do to handle the enter foreground notification
    [self RefreshListTable];
    //NSLog(@"handleEnterForeground");
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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *RefreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshBTClicked)];
    self.navigationItem.leftBarButtonItem = RefreshButton;
    UIBarButtonItem *NewTogetherButton = [[UIBarButtonItem alloc] initWithTitle:@"새투게더" style:UIBarButtonItemStyleBordered target:self action:@selector(NewTogetherMake)];
    self.navigationItem.rightBarButtonItem = NewTogetherButton;
    [RefreshButton release];
    [NewTogetherButton release];
    TogetherDataArray=[[NSMutableArray alloc]init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthPage) name:@"checkDBInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBTClicked) name:@"RequestTogetherListToRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushdownModalView) name:@"VerificationPush" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBTClicked) name:@"applicationWillEnterForeground" object:nil];
    
    dfOnlyDate=[[NSDateFormatter alloc]init];
    [dfOnlyDate setDateFormat:@"MM/dd(ccc)"];
    [dfOnlyDate setWeekdaySymbols:[NSArray arrayWithObjects:@"일",@"월",@"화",@"수",@"목",@"금",@"토",nil]];
    dfInputFormat=[[NSDateFormatter alloc]init];
    [dfInputFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    dfTableCellDateFormat=[[NSDateFormatter alloc]init];
    [dfTableCellDateFormat setDateFormat:@"aa hh:mm"];
    [dfTableCellDateFormat setAMSymbol:@"오전"];
    [dfTableCellDateFormat setPMSymbol:@"오후"];
    
    Day=[[NSMutableArray alloc]init];
    tableArray=[[NSMutableArray alloc]init];
    sectionArray=[[NSMutableArray alloc]init];
    filteredArray=[[NSMutableArray alloc]init];
    filteredTableArray=[[NSMutableArray alloc]init];
    filteredSectionArray=[[NSMutableArray alloc]init];
    filteredDay=[[NSMutableArray alloc]init];
    
    for(int i=0;i<=6;i++)
    {
        [Day addObject:[[[NSMutableArray alloc]init] autorelease]];
        [filteredDay addObject:[[[NSMutableArray alloc]init]autorelease]];
    }
    networkHandler = [NetworkHandler getNetworkHandler];
    
    if ( ![self checkDBInfo] ){
        [self showAuthPage];
    }
    else{
        [self RefreshListTable];
    }
    //[self checkDBInfo];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //NSLog(@"viewDidAppear");
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
    if(tableView==self.searchDisplayController.searchResultsTableView)
    {
        //NSLog(@"sectionCount:%d",[filteredSectionArray count]);
        return [filteredSectionArray count];
    }
    return [sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(tableView==self.searchDisplayController.searchResultsTableView)
    {
        //NSLog(@"section:%d,count%d",section,[[filteredTableArray objectAtIndex:section]count]);
        return [[filteredTableArray objectAtIndex:section]count];
    }
    
    return [[tableArray objectAtIndex:section]count];
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    int c=0;
    if([sectionArray count]!=0&&tableView==self.tableView)
    {
        c=[[sectionArray objectAtIndex:section]intValue];
    }
    else if([filteredSectionArray count]!=0&&tableView==self.searchDisplayController.searchResultsTableView)
    {
        c=[[filteredSectionArray objectAtIndex:section]intValue];
    }
    NSString *strDay;
    if(c==0)
        strDay=@"오늘";
    else if(c==1)
        strDay=@"내일";
    else if(c==2)
        strDay=@"모레";
    else
        strDay=[NSString stringWithFormat:@"%d일 후",c];
    
    if(tableView==self.tableView)
    {
        return [NSString stringWithFormat:@"%@ - %@",
            [dfOnlyDate stringFromDate:[dfInputFormat dateFromString:[[[tableArray objectAtIndex:section]objectAtIndex:0]objectForKey:@"departtime"]]],strDay];
    }
    else if(tableView==self.searchDisplayController.searchResultsTableView)
    {
        return [NSString stringWithFormat:@"%@ - %@",
                [dfOnlyDate stringFromDate:[dfInputFormat dateFromString:[[[filteredTableArray objectAtIndex:section]objectAtIndex:0]objectForKey:@"departtime"]]],strDay];
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TogetherListCell";
    
    NSDate *NSDateDeparttime;
    NSString* departure;
    NSString* destination;
    if(tableView==self.tableView)
    {
        departure = [[[tableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"departure"];
        destination = [[[tableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"destination"];
        NSDateDeparttime=[dfInputFormat dateFromString:[[[tableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"departtime"]];
    }
    else if(tableView==self.searchDisplayController.searchResultsTableView)
    {
        departure = [[[filteredTableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]objectForKey:@"departure"];
        destination = [[[filteredTableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"destination"];
        NSDateDeparttime=[dfInputFormat dateFromString:[[[filteredTableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"departtime"]];
    }
    
    UIFont* defaultFont = [UIFont systemFontOfSize:15];
    
    CGSize depaSize = [departure sizeWithFont:defaultFont];
    CGSize destSize =[destination sizeWithFont:defaultFont];
    
    NSString *strDepDes;
    //NSLog(@"depa %f, dest %f", depaSize.width, destSize.width);
    if ( depaSize.width + destSize.width < CONTENT_WIDTH )
    {
    }
    else if ( depaSize.width < HALF_CONTENT_WIDTH )
    {
        destination = [self stringByTruncatingToWidth:CONTENT_WIDTH-depaSize.width withFont:defaultFont withString:destination];
    }
    else if ( destSize.width < HALF_CONTENT_WIDTH )
    {
        departure = [self stringByTruncatingToWidth:CONTENT_WIDTH-destSize.width withFont:defaultFont withString:departure];
    }
    else if ( destSize.width + depaSize.width >= CONTENT_WIDTH )
    {
        departure = [self stringByTruncatingToWidth:HALF_CONTENT_WIDTH withFont:defaultFont withString:departure];
        destination = [self stringByTruncatingToWidth:HALF_CONTENT_WIDTH withFont:defaultFont withString:destination];
    }
    //NSLog(@"depa %@ ; dest %@", departure, destination);
    strDepDes=[NSString stringWithFormat:@"%@ ➜ %@", departure, destination];
    
    NSString *strPeopleCount;
    
    if(tableView==self.tableView)
    {
        strPeopleCount=[[NSString alloc]initWithFormat:@"%d/%@",
                        [[[[tableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"nofparticipants"]intValue],[[[tableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"capacity"]];
    }
    else if(tableView==self.searchDisplayController.searchResultsTableView)
    {
        strPeopleCount=[[NSString alloc]initWithFormat:@"%d/%@",
                              [[[[filteredTableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"nofparticipants"]intValue],[[[filteredTableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"capacity"]];
    }
    TogetherListTableViewCell *cell= (TogetherListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        NSArray* nib=[[NSBundle mainBundle] loadNibNamed:@"TogetherListTableViewCell" owner:self options:nil];
        cell=(TogetherListTableViewCell *)[nib objectAtIndex:0];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    // Configure the cell...
    if(tableView==self.tableView)
    {
        cell.place.text= strDepDes;       
        cell.departtime.text= [dfTableCellDateFormat stringFromDate:NSDateDeparttime];
        cell.peoplecount.text=strPeopleCount;

    }
    else if(tableView==self.searchDisplayController.searchResultsTableView)
    {
        cell.place.text= strDepDes;
        cell.departtime.text= [dfTableCellDateFormat stringFromDate:NSDateDeparttime];
        cell.peoplecount.text=strPeopleCount;
    }
    if ( tableView==self.tableView&&[(NSNumber *)[[[tableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"my"] 
          intValue] == 1){
        cell.place.textColor = [UIColor blueColor];
        cell.peoplecount.textColor = [UIColor blueColor];
        cell.departtime.textColor=[UIColor blueColor];
    
        UITableViewCell *bgView = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        bgView.backgroundColor= [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1];
        cell.backgroundView=bgView;
        //cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else if ( tableView==self.searchDisplayController.searchResultsTableView&&[(NSNumber *)[[[filteredTableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"my"] 
                                     intValue] == 1){
        cell.place.textColor = [UIColor blueColor];
        cell.peoplecount.textColor = [UIColor blueColor];
        cell.departtime.textColor=[UIColor blueColor];
        
        UITableViewCell *bgView = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        bgView.backgroundColor= [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1];
        cell.backgroundView=bgView;
        //cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    //[NSDateDeparttime release];
    [strPeopleCount release];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int indexLocation=0;

    for(int i=0;i<indexPath.section;i++)
    {
        if(tableView==self.tableView)
        {
            indexLocation+=[[tableArray objectAtIndex:i]count];
        }
        else if(tableView==self.searchDisplayController.searchResultsTableView)
        {
            indexLocation+=[[filteredTableArray objectAtIndex:i]count];
        }
    }
    if(tableView!=self.searchDisplayController.searchResultsTableView&&indexLocation+indexPath.row==cellcount-1 && [TogetherDataArray count]!=0 )
    {
        [self requestMoreTogetherData];
    }
    else if(tableView==self.searchDisplayController.searchResultsTableView&&indexLocation+indexPath.row==searchcellcount-1&&[TogetherDataArray count]!=0)
    {
        [self requestMoreTogetherData];
        [self.searchDisplayController.delegate searchDisplayController:self.searchDisplayController shouldReloadTableForSearchString:self.searchDisplayController.searchBar.text];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark -Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO when is my together set value for detail view or make background return myTogether bool
    
    DetailTogetherView* DTV = [[DetailTogetherView alloc]init];

    /*if ( [(NSNumber *)[[[tableArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"my"] 
          intValue] == 0){
        [networkHandler hasTogetherWithDelegate:DTV];
    }*/

    if(tableView==self.tableView)
    {
        DTV.togetherID = [[[tableArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"id"];
    }
    else if(tableView==self.searchDisplayController.searchResultsTableView)
    {
        DTV.togetherID = [[[filteredTableArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"id"];
        DTV.togetherListSearchDisplayController=self.searchDisplayController;
    }
    [self.navigationController pushViewController:DTV animated:YES];
    [DTV release];
    
}


#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */	
    pullToRefreshActive=FALSE;
	[filteredArray removeAllObjects]; // First clear the filtered array.
    searchcellcount=0;
    
    if ([scope isEqualToString:@"출발지"])
    {
        for (int i=0;i<[tableArray count];i++)
        {	
            for (int n=0;n<[[tableArray objectAtIndex:i] count];n++)
            {
                if([[[[tableArray objectAtIndex:i] objectAtIndex:n] objectForKey:@"departure"] rangeOfString:searchText].location != NSNotFound)
                {
                    [filteredArray addObject:[[tableArray objectAtIndex:i]objectAtIndex:n]];
                    searchcellcount++;
                }
                
            }
        }
        [self regroupTogetherDataWithClearing:YES
                                  sourceArray:filteredArray
                                     dayArray:filteredDay
                                 sectionArray:filteredSectionArray 
                                   tableArray:filteredTableArray];
    }
    else if([scope isEqualToString:@"도착지"])
    {
        for (int i=0;i<[tableArray count];i++)
        {	
            for (int n=0;n<[[tableArray objectAtIndex:i] count];n++)
            {
                if([[[[tableArray objectAtIndex:i] objectAtIndex:n] objectForKey:@"destination"] rangeOfString:searchText].location != NSNotFound)
                {
                    [filteredArray addObject:[[tableArray objectAtIndex:i]objectAtIndex:n]];
                    searchcellcount++;
                }
                
            }
        }
        [self regroupTogetherDataWithClearing:YES
                                  sourceArray:filteredArray
                                     dayArray:filteredDay
                                 sectionArray:filteredSectionArray 
                                   tableArray:filteredTableArray];
    }     
}


#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    pullToRefreshActive=YES;
    [self refreshBTClicked];
}
@end
