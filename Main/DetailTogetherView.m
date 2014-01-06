//
//  DetailTogetherView.m
//  TaxiTogether
//
//  Created by 정 창제 on 11. 7. 29..
//  Copyright 2011년 KAIST. All rights reserved.
//

#import "DetailTogetherView.h"
#import "SBJsonParser.h"
#import "DBHandler.h"
#import "NetworkHandler.h"
#import "DetailTogetherViewCell.h"
#import "DetailTogetherDescriptionCellController.h"
#import "DetailTogetherViewParticipantsCell.h"
#import "DetailTogetherMapView.h"

#define DESC_CELL_HEIGHT 60.0
#define DESC_CELL_CONTENT_HEIGHT 18.0
#define DESC_CELL_CONTENT_WIDTH 251.0

#define DEFAULT_CELL_CONTENT_WIDTH 175.0
#define DEFAULT_CELL_CONTENT_HEIGHT 40.0

@implementation DetailTogetherView
@synthesize togetherID,btParticipate,ProgressView,togetherListSearchDisplayController, isMyTogether;

-(void)requestData{

    ProgressView.center=CGPointMake(160, self.tableView.contentOffset.y+190);
    [self.view addSubview:ProgressView];
    [self.view setUserInteractionEnabled:NO];
    DBHandler *dbHandler=[DBHandler getDBHandler];
	NetworkHandler* networkHandler=[NetworkHandler getNetworkHandler];
	[networkHandler grabURLInBackground:@"grep/get_together/" 
							 callObject:self 
							requestDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                         togetherID,@"together",
                                         [dbHandler.userinfo objectForKey:@"userid"],@"userid",
                                         [dbHandler.userinfo objectForKey:@"key"],@"key",
                                         nil]						  
								 method:@"POST" alert:YES];
    if (![networkHandler isNetworkReachableWithAlert:NO]) {
        [ProgressView removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
    }
    
}

-(IBAction)participateTogether{
    [self.view addSubview:ProgressView];
    NetworkHandler *networkHandler=[NetworkHandler getNetworkHandler];
    DBHandler *dbHandler = [DBHandler getDBHandler];
    NSMutableDictionary *requestDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                      [dbHandler.userinfo objectForKey:@"userid"],@"userid",
                                      [dbHandler.userinfo objectForKey:@"key"],@"key",
                                      togetherID,@"roomid",
                                      nil];
    [networkHandler grabURLInBackground:@"participants/add_member/" callObject:self requestDict:requestDict method:@"POST" alert:YES];
    [requestDict release];

}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString =[request responseString];
    //NSLog(responseString);
    SBJsonParser* json = [[SBJsonParser alloc]init];
	NSDictionary *dataString = [json objectWithString:responseString];
    int errorcode = [[dataString objectForKey:@"errorcode"]intValue];
    if(errorcode==800)
    {
        dataDict=[dataString objectForKey:@"info"];
        [dataDict retain];
        depa_increased = [self getLineHeightForData :[dataDict objectForKey:@"departure"]];
        dest_increased = [self getLineHeightForData :[dataDict objectForKey:@"destination"]];
        desc_increased = [self getLineHeightForData :[dataDict objectForKey:@"description"]];
        
        participantsStr=@"";
        isMyTogether = [[dataDict objectForKey:@"my"] intValue];
        if ( isMyTogether ) {
            [btParticipate setTitle:@"나의 투게더입니다" forState:UIControlStateNormal];
            [btParticipate setTitle:@"나의 투게더입니다" forState:UIControlStateDisabled];
            [btParticipate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btParticipate setEnabled:NO];
        }
        else {
            [btParticipate setTitle:@"참가하기" forState:UIControlStateNormal];
            [btParticipate setTitle:@"참가하기" forState:UIControlStateDisabled];
            [btParticipate setTitleColor:[UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0] forState:UIControlStateNormal];
            [btParticipate setEnabled:YES];
        }
        
        numberOfParticipants = [[dataDict objectForKey:@"participants"]count]; 
        for(int i=0;i<numberOfParticipants;i++)
        {
            NSString *gender=[NSString stringWithFormat:@"%@",[[[dataDict objectForKey:@"participants"]objectAtIndex:i]objectForKey:@"gender"]];
            
            if([gender isEqualToString:@"M"])
            {
                participantsStr=[participantsStr stringByAppendingFormat:@"%@  남\n",[[[dataDict objectForKey:@"participants"]objectAtIndex:i]objectForKey:@"id"]];
            }
            else if([gender isEqualToString:@"F"])
            {
                participantsStr=[participantsStr stringByAppendingFormat:@"%@  여\n",[[[dataDict objectForKey:@"participants"]objectAtIndex:i]objectForKey:@"id"]];
            }
            
        }
        [participantsStr retain];
        
    }
    else if(errorcode==803)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        //[[[[UIAlertView alloc]initWithTitle:@"오류" message:@"존재하지 않는 투게더 입니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==400)
    {
        [[[[UIAlertView alloc]initWithTitle:nil message:@"성공적으로 참여하였습니다!" delegate:self cancelButtonTitle:@"나의 투게더" otherButtonTitles:nil, nil]autorelease ]show];
        
    }
    else if(errorcode==402)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        //[[[[UIAlertView alloc]initWithTitle:@"오류" message:@"존재하지 않는 투게더 입니다" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==403)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"(403)개발자에게 문의하세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==404)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"이미 꽉 찬 투게더입니다" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==405)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"(405)개발자에게 문의하세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==406)
    {
        [[[[UIAlertView alloc]initWithTitle:@"어이쿠!" message:@"이미 참여한 투게더가 있습니다!" delegate:self cancelButtonTitle:@"나의 투게더" otherButtonTitles:nil, nil]autorelease ]show];
    }
    else if(errorcode==407)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"이미 지나간 투게더입니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:[NSString stringWithFormat:@"(%@)개발자에게 문의해주세요.",[dataString objectForKey:@"errorcode"]] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease ]show];
    }
    [json release];
	[self.tableView reloadData];
    [ProgressView removeFromSuperview];
    [self.view setUserInteractionEnabled:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    if ([error code] == ASIRequestTimedOutErrorType && self.tabBarController.selectedIndex == 0 ) {
        // Actions specific to timeout
        
        [[[[UIAlertView alloc]initWithTitle:@"네트워크 오류" message:@"RequestTimeOut.\n다시 시도해 보세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    [ProgressView removeFromSuperview];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"DetailTogetherView" bundle:nil];
    if (self) {
        // Custom initialization
        togetherID=[[NSNumber alloc]init];
        dfDateFormat=[[NSDateFormatter alloc]init];
        [dfDateFormat setDateFormat:@"MM/dd(ccc)"];
        [dfDateFormat setWeekdaySymbols:[NSArray arrayWithObjects:@"일",@"월",@"화",@"수",@"목",@"금",@"토",nil]];
        dfTimeFormat=[[NSDateFormatter alloc]init];
        [dfTimeFormat setDateFormat:@"aa hh:mm"];
        [dfTimeFormat setAMSymbol:@"오전"];
        [dfTimeFormat setPMSymbol:@"오후"];
        dfInputFormat=[[NSDateFormatter alloc]init];
        [dfInputFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        participantsStr=[[NSString alloc]initWithString:@""];
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
    [self.navigationItem setTitle:@"투게더 상세보기"];
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"applicationWillEnterForeground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"quitTogether" object:nil];

}
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController popToRootViewControllerAnimated:YES];
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
    return 6;
}


- (BOOL) selectingForDefaultWithData: (NSString*)data
{
    CGSize cell = CGSizeMake(DEFAULT_CELL_CONTENT_WIDTH , 9999);
    
    CGSize newSize = [data
                      sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:cell
                      lineBreakMode:UILineBreakModeWordWrap];
    
    return newSize.height <= DEFAULT_CELL_CONTENT_HEIGHT;
}

- (CGFloat) getLineHeightForData : (NSString*)data
{
    CGSize cell = CGSizeMake(DESC_CELL_CONTENT_WIDTH , 9999);
    
    CGSize newSize = [data
                      sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:cell
                      lineBreakMode:UILineBreakModeWordWrap];
    CGFloat labelHeight= newSize.height;
    
    if ( labelHeight < DESC_CELL_CONTENT_HEIGHT )
    {
        labelHeight = DESC_CELL_HEIGHT;
    }
    else 
    {
        labelHeight = DESC_CELL_HEIGHT - DESC_CELL_CONTENT_HEIGHT + labelHeight;
  
    }
        //NSLog(@"%f label height", labelHeight);
    return labelHeight;
}

-(CGFloat) getLineHeightForParticipants
{
    CGFloat labelHeight = numberOfParticipants *21+ 5;
    //NSLog(@"%f height", labelHeight);
    return labelHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( [indexPath row] == 2 && ![self selectingForDefaultWithData: [dataDict objectForKey:@"departure"]])
    {
        return depa_increased;
    }
    else if ( [indexPath row] == 3 && ![self selectingForDefaultWithData: [dataDict objectForKey:@"destination"]])
    {
        return dest_increased;
    }
    else if ( [indexPath row] == 4 && ![self selectingForDefaultWithData: [dataDict objectForKey:@"description"]]) {
        return desc_increased;
    }
    else if([indexPath row] == 5){
        CGFloat labelHeight = [self getLineHeightForParticipants];
        return labelHeight + 40;
    }
    else {
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *DescCellIdentifier = @"DetailDescCell";
    static NSString *PartCellIdentifier = @"PartDescCell";    
    DetailTogetherViewCell *cell= (DetailTogetherViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        NSArray* nib=[[NSBundle mainBundle] loadNibNamed:@"DetailTogetherViewCell" owner:self options:nil];
        cell=(DetailTogetherViewCell *)[nib objectAtIndex:0];
    }
    
    DetailTogetherDescriptionCellController *descCell = (DetailTogetherDescriptionCellController *)
    [tableView dequeueReusableCellWithIdentifier:DescCellIdentifier];
    if(descCell==nil){
        NSArray* nib=[[NSBundle mainBundle] loadNibNamed:@"DetailTogetherDescriptionCell" owner:self options:nil];
        descCell=(DetailTogetherDescriptionCellController *)[nib objectAtIndex:0];
    }
    
    descCell.descdesc.font = [UIFont systemFontOfSize:14.0];
    [descCell.descdesc setNumberOfLines:0];
    [descCell.descdesc setLineBreakMode:UILineBreakModeCharacterWrap];
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.title.text=@"날짜";
            cell.content.text=[dfDateFormat stringFromDate:[dfInputFormat dateFromString:[dataDict objectForKey:@"departtime"]]];
            break;
        case 1:
            cell.title.text=@"시간";
            cell.content.text=[dfTimeFormat stringFromDate:[dfInputFormat dateFromString:[dataDict objectForKey:@"departtime"]]];
            break;
        case 2:
            if ( [self selectingForDefaultWithData:[dataDict objectForKey:@"departure"]]){
                cell.title.text=@"출발지";
                cell.content.text=[dataDict objectForKey:@"departure"];    
                if([[dataDict objectForKey:@"depa_lat"]isEqualToString:@""]||[[dataDict objectForKey:@"depa_long"]isEqualToString:@""])
                {
                    cell.userInteractionEnabled=NO;
                    
                }
                else
                {
                    cell.userInteractionEnabled = YES;
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
            }
            else {

                descCell.desctitle.text = @"출발지";
                descCell.descdesc.frame = CGRectMake(descCell.descdesc.frame.origin.x,
                                                     descCell.descdesc.frame.origin.y,
                                                     descCell.descdesc.frame.size.width,
                                                     descCell.descdesc.frame.size.height+depa_increased - DESC_CELL_HEIGHT);
                descCell.descdesc.text = [dataDict objectForKey:@"departure"];
                if([[dataDict objectForKey:@"depa_lat"]isEqualToString:@""]||[[dataDict objectForKey:@"depa_long"]isEqualToString:@""])
                {
                    descCell.userInteractionEnabled=NO;
                }
                else
                {
                    descCell.userInteractionEnabled = YES;
                    descCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
                return descCell;
            }
            break;
        case 3:
            if ( [self selectingForDefaultWithData:[dataDict objectForKey:@"destination"]]){
                cell.title.text=@"도착지";
                cell.content.text=[dataDict objectForKey:@"destination"]; 
                if([[dataDict objectForKey:@"dest_lat"]isEqualToString:@""]||[[dataDict objectForKey:@"dest_long"]isEqualToString:@""])
                {
                    cell.userInteractionEnabled=NO;
                }
                else
                {
                    cell.userInteractionEnabled = YES;
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
            }
            else {                
                
                descCell.desctitle.text = @"도착지";
                descCell.descdesc.frame = CGRectMake(descCell.descdesc.frame.origin.x,
                                                     descCell.descdesc.frame.origin.y,
                                                     descCell.descdesc.frame.size.width,
                                                     descCell.descdesc.frame.size.height+dest_increased - DESC_CELL_HEIGHT);
                descCell.descdesc.text = [dataDict objectForKey:@"destination"];
                if([[dataDict objectForKey:@"dest_lat"]isEqualToString:@""]||[[dataDict objectForKey:@"dest_long"]isEqualToString:@""])
                {
                    descCell.userInteractionEnabled=NO;
                }
                else
                {
                    descCell.userInteractionEnabled = YES;
                    descCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
                return descCell;
            }
            break;
        case 4:
            if ([self selectingForDefaultWithData:[dataDict objectForKey:@"description"]]){
                //NSLog(@"default is selected");
                cell.title.text=@"설명";
                cell.content.text=[dataDict objectForKey:@"description"];
            }
            else{

                descCell.desctitle.text = @"설명";
                descCell.descdesc.frame = CGRectMake(descCell.descdesc.frame.origin.x,
                                                     descCell.descdesc.frame.origin.y,
                                                     descCell.descdesc.frame.size.width,
                                                     descCell.descdesc.frame.size.height+desc_increased - DESC_CELL_HEIGHT);
                descCell.descdesc.text = [dataDict objectForKey:@"description"];
                return descCell;
            }
            break;
        case 5:
        {
            DetailTogetherViewParticipantsCell *partCell=(DetailTogetherViewParticipantsCell *)[tableView dequeueReusableCellWithIdentifier:PartCellIdentifier];
            if(partCell==nil){
                NSArray* nib=[[NSBundle mainBundle] loadNibNamed:@"DetailTogetherViewParticipantsCell" owner:self options:nil];
                partCell=(DetailTogetherViewParticipantsCell *)[nib objectAtIndex:0];
            }
            
            //NSArray *tmpArr = [dataDict objectForKey:@"participants"];
            //partIncreased=[self getLineHeightForParticipants];
            //partCell.content.font = [UIFont systemFontOfSize:14.0];
            partCell.content.frame = CGRectMake(partCell.content.frame.origin.x, partCell.content.frame.origin.y, 
                                                partCell.content.frame.size.width,numberOfParticipants* 21);
            [partCell.content setNumberOfLines:0];
            [partCell.content setLineBreakMode:UILineBreakModeWordWrap];
            
            partCell.title.text = [[[NSString alloc] initWithFormat:@"%@ (%d/%d)", @"참가자 정보", numberOfParticipants, [[dataDict objectForKey:@"capacity"] intValue]]autorelease];
            partCell.content.text = participantsStr;
            return partCell;
            break;
        }
        default:
            break;
    }
    return cell;
}

 -(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
    return @"Information";
 }
 
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0)
    {
        DetailTogetherMapView *mapView = [[DetailTogetherMapView alloc]initWithNibName:@"DetailTogetherMapView" bundle:nil];
        if(indexPath.row==2)
        {
            mapView.SelectType=@"departure";
            mapView.DataDict=dataDict;
            [self presentModalViewController:mapView animated:YES];
        }
        else if(indexPath.row==3)
        {
            mapView.SelectType=@"destination";
            mapView.DataDict=dataDict;
            [self presentModalViewController:mapView animated:YES];
        }
        [mapView release];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - AlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        self.tabBarController.selectedViewController=[self.tabBarController.viewControllers objectAtIndex:1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestTogetherListToRefresh" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyTogetherViewRefresh" object:nil];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
}

@end
