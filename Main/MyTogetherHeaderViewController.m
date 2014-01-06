//
//  MyTogetherHeaderViewController.m
//  TaxiTogether
//
//  Created by Fragarach on 7/28/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import "MyTogetherHeaderViewController.h"
#import "MyTogetherHeaderViewCellController.h"
#import "MyTogetherParticipantsViewController.h"  
#import "MyTogetherHeaderDescriptionCellController.h"
#import "MyTogetherHeaderParticipantsViewCell.h"
#import "MyTogetherMapView.h"
#import "DBHandler.h"
#import "SBJsonParser.h"

#define DESC_CELL_HEIGHT 60.0
#define DESC_CELL_CONTENT_HEIGHT 18.0
#define DESC_CELL_CONTENT_WIDTH 251.0
#define DESC_CELL_DEFAULT_HEIGHT 40.0


@implementation MyTogetherHeaderViewController
@synthesize participants,myTogether,quitTogetherButton,ProgressView,myTogetherView,myTogetherViewController;
@synthesize navigationController,tabBarController,commentTable;
@synthesize depa_increased, dest_increased, desc_increased, increased, isPassed;
@synthesize participantsStr, numberOfParticipants;

/*
-(IBAction) viewParticipantsView
{
    //NSLog(@"viewParticipants");
    if([networkHandler isNetworkReachableWithAlert:YES]){
        MyTogetherParticipantsViewController *participantsView =[[MyTogetherParticipantsViewController alloc]init];
        participantsView.togetherId = (NSString*)[myTogether objectForKey:@"id"];
        
        [navigationController pushViewController:participantsView animated:YES];
        [participantsView release];
    }
}
 */

-(IBAction) quitAsk
{
    UIAlertView *quitAsk=[[[UIAlertView alloc]initWithTitle:nil message:@"정말로 투게더에서 나오시겠어요?" delegate:self cancelButtonTitle:@"네" otherButtonTitles:@"아니요", nil] autorelease];
    quitAsk.tag=0;
    [quitAsk show];
}
-(IBAction) quitTogether
{
    ProgressView.center=CGPointMake(160,commentTable.contentOffset.y+190);
    [myTogetherView addSubview:ProgressView];
    DBHandler *dbHandler=[DBHandler getDBHandler];
    
    NSMutableDictionary *requestDict=[[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                       [dbHandler.userinfo objectForKey:@"userid"],@"userid",
                                       [dbHandler.userinfo objectForKey:@"key"],@"key",
                                       [myTogether objectForKey:@"id"],@"roomid", 
                                       nil]autorelease];
    [networkHandler grabURLInBackground:@"participants/delete_member/" callObject:self requestDict:requestDict method:@"POST" alert:YES];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSString *responseString =[request responseString];
    //NSLog(responseString);
    SBJsonParser* json = [SBJsonParser alloc];
	NSDictionary *dataString = [json objectWithString:responseString];
    int errorcode=[[dataString objectForKey:@"errorcode"]intValue];
    if(errorcode==500)
    {
        [[[[UIAlertView alloc]initWithTitle:@"" message:@"정상적으로 탈퇴되었습니다" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil , nil]autorelease ]show];
        [[tabBarController.viewControllers objectAtIndex:0]popToRootViewControllerAnimated:YES];
        tabBarController.selectedViewController=[self.tabBarController.viewControllers objectAtIndex:0];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RequestTogetherListToRefresh" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MyTogetherViewRefresh" object:nil];
    }
    else if(errorcode==501)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"당신은 이 투게더에 속해있지 않습니다" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==502)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"투게더가 존재하지 않습니다" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==503)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"(503)개발자에게 문의해주세요" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==504)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"이미 지나간 투게더입니다" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
        quitTogetherButton.enabled=FALSE;
    }
    else if(errorcode==505)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"(505)개발자에게 문의해주세요" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else
    {
        [[[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"(%@)개발자에게 문의해주세요",[dataString objectForKey:@"errorcode"]] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease ]show];
    }
    
    //NSLog(@"requestFinished");
    [json release];
    [self.tableView reloadData];
    [ProgressView removeFromSuperview];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    if ([error code] == ASIRequestTimedOutErrorType && self.tabBarController.selectedIndex == 1 ) {
        // Actions specific to timeout
        [[[[UIAlertView alloc]initWithTitle:@"네트워크 오류" message:@"RequestTimeOut.\n다시 시도해 보세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
        
    }
    [ProgressView removeFromSuperview];
    
}




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
    [dfTimeFormat dealloc];
    [dfDateFormat dealloc];
    [dfInputFormat dealloc];
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
    networkHandler=[NetworkHandler getNetworkHandler];
    [quitTogetherButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    dfDateFormat=[[NSDateFormatter alloc]init];
    [dfDateFormat setDateFormat:@"MM/dd(ccc)"];
    [dfDateFormat setWeekdaySymbols:[NSArray arrayWithObjects:@"일",@"월",@"화",@"수",@"목",@"금",@"토",nil]];
    dfTimeFormat=[[NSDateFormatter alloc]init];
    [dfTimeFormat setDateFormat:@"aa hh:mm"];
    [dfTimeFormat setAMSymbol:@"오전"];
    [dfTimeFormat setPMSymbol:@"오후"];
    dfInputFormat=[[NSDateFormatter alloc]init];
    [dfInputFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    

    
    selectedIndexArray = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
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


-(CGFloat) getLineHeightForParticipants
{
    CGFloat labelHeight = numberOfParticipants *21+ 5;
    return labelHeight;
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

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"투게더 정보";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (row == 2 ){
        return depa_increased ? depa_increased : DESC_CELL_DEFAULT_HEIGHT;
    }
    else if ( row == 3 ){
        return dest_increased ? dest_increased : DESC_CELL_DEFAULT_HEIGHT;    
    }
    else if ( row == 4 ){
        return desc_increased ? desc_increased : DESC_CELL_DEFAULT_HEIGHT;    
    }
    else if ( row == 5 ){
        CGFloat labelHeight = [self getLineHeightForParticipants];
        return labelHeight + 40;
    }
    else{
        return 40;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyTogetherHeaderViewCell";
    static NSString *DescCellIdentifier = @"MyTogetherHeaderDescViewCell";
    
    MyTogetherHeaderViewCellController *cell= (MyTogetherHeaderViewCellController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        NSArray* nib=[[NSBundle mainBundle] loadNibNamed:@"MyTogetherHeaderViewCell" owner:self options:nil];
        cell=(MyTogetherHeaderViewCellController *)[nib objectAtIndex:0];
    }
    
    MyTogetherHeaderDescriptionCellController *descCell = (MyTogetherHeaderDescriptionCellController *)
    [tableView dequeueReusableCellWithIdentifier:DescCellIdentifier];
    if(descCell==nil){
        NSArray* nib=[[NSBundle mainBundle] loadNibNamed:@"MyTogetherHeaderDescriptionCell" owner:self options:nil];
        descCell=(MyTogetherHeaderDescriptionCellController *)[nib objectAtIndex:0];
    }
    
    descCell.descdesc.font = [UIFont systemFontOfSize:14.0];
    [descCell.descdesc setNumberOfLines:0];
    [descCell.descdesc setLineBreakMode:UILineBreakModeCharacterWrap];

    
    int row = [indexPath row];
    
    if (row == 0)
    {
        cell.title.text = @"날짜";
        cell.content.text = [dfDateFormat stringFromDate:[dfInputFormat dateFromString:[myTogether objectForKey:@"departtime"]]];
        if ( isPassed )
        {
            cell.content.textColor = [UIColor redColor];
        }
    } 
    else if (row == 1)
    {
        cell.title.text = @"시간";
        cell.content.text = [dfTimeFormat stringFromDate:[dfInputFormat dateFromString:[myTogether objectForKey:@"departtime"]]];   
        if ( isPassed )
        {
            cell.content.textColor = [UIColor redColor];
        }
    }
    else if (row == 2)
    {
        if (depa_increased)
        {
            //NSLog(@"row 3 is called");            
            descCell.descTitle.text = @"출발지";
            descCell.descdesc.frame = CGRectMake(descCell.descdesc.frame.origin.x,
                                                 descCell.descdesc.frame.origin.y,
                                                 descCell.descdesc.frame.size.width,
                                                 descCell.descdesc.frame.size.height+depa_increased - DESC_CELL_HEIGHT);
            
            descCell.descdesc.text = [myTogether objectForKey:@"departure"];
            descCell.userInteractionEnabled = NO;
            if(!([[myTogether objectForKey:@"depa_lat"] isEqualToString:@""] || [[myTogether objectForKey:@"depa_long"] isEqualToString:@""]))
            {
                descCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                descCell.userInteractionEnabled=YES;
            }
            return descCell;
        }
        else{
            cell.title.text = @"출발지";
            cell.content.text = [myTogether objectForKey:@"departure"];
            cell.userInteractionEnabled=NO; 
            if(!([[myTogether objectForKey:@"depa_lat"] isEqualToString:@""] || [[myTogether objectForKey:@"depa_long"] isEqualToString:@""]))
            {
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                cell.userInteractionEnabled=YES;
            }
        }
    }
    else if (row == 3)
    {
        if (dest_increased)
        {
            //NSLog(@"row 3 destination is called");            
            descCell.descTitle.text = @"도착지";
            descCell.descdesc.frame = CGRectMake(descCell.descdesc.frame.origin.x,
                                                 descCell.descdesc.frame.origin.y,
                                                 descCell.descdesc.frame.size.width,
                                                 descCell.descdesc.frame.size.height+dest_increased - DESC_CELL_HEIGHT);
            
            descCell.descdesc.text = [myTogether objectForKey:@"destination"];
            descCell.userInteractionEnabled=NO;
            if(!([[myTogether objectForKey:@"dest_lat"] isEqualToString:@""] || [[myTogether objectForKey:@"dest_long"] isEqualToString:@""]))
            {
                descCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                descCell.userInteractionEnabled=YES;
            }
            return descCell;
        }
        else
        {
                        //NSLog(@"row 3 destination is default called");            
            cell.title.text = @"도착지";
            cell.content.text = [myTogether objectForKey:@"destination"];   
            cell.userInteractionEnabled=NO;
            if(!([[myTogether objectForKey:@"dest_lat"] isEqualToString:@""] || [[myTogether objectForKey:@"dest_long"] isEqualToString:@""]))
            {
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                cell.userInteractionEnabled=YES;
            }
        }
    }
    else if (row == 4)
    {
        if (desc_increased)
        {
            //NSLog(@"row 3 is called");            
            descCell.descTitle.text = @"설명";
            descCell.descdesc.frame = CGRectMake(descCell.descdesc.frame.origin.x,
                                                 descCell.descdesc.frame.origin.y,
                                                 descCell.descdesc.frame.size.width,
                                                 descCell.descdesc.frame.size.height+desc_increased - DESC_CELL_HEIGHT);
            
            descCell.descdesc.text = [myTogether objectForKey:@"description"];
            return descCell;
        }
        else {
            cell.content.text = [myTogether objectForKey:@"description"];
            cell.title.text = @"설명";
            return cell;
        }

    }    
    else if ( row == 5)
    {

        NSString *HeaderPartCellIdentifier = @"MyTogetherHeaderParticipants";
        MyTogetherHeaderParticipantsViewCell *partCell=(MyTogetherHeaderParticipantsViewCell *)[tableView dequeueReusableCellWithIdentifier:HeaderPartCellIdentifier];
        if(partCell==nil){
            NSArray* nib=[[NSBundle mainBundle] loadNibNamed:@"MyTogetherHeaderParticipantsViewCell" owner:self options:nil];
            partCell=(MyTogetherHeaderParticipantsViewCell *)[nib objectAtIndex:0];
        }
        
        partCell.content.frame = CGRectMake(partCell.content.frame.origin.x, partCell.content.frame.origin.y, 
                                            partCell.content.frame.size.width,numberOfParticipants* 21);
        [partCell.content setNumberOfLines:0];
        [partCell.content setLineBreakMode:UILineBreakModeWordWrap];
        
        partCell.title.text = [[[NSString alloc] initWithFormat:@"%@ (%d/%d)", @"참가자 정보", numberOfParticipants, [[myTogether objectForKey:@"capacity"] intValue]]autorelease];
        partCell.content.text = participantsStr;

        if ( numberOfParticipants <= 0 ) {
            partCell.userInteractionEnabled = NO;
            partCell.accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            partCell.userInteractionEnabled = YES;
            partCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return partCell;       
        
    }
    // Configure the cell...
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    if(indexPath.section==0)
    {
        MyTogetherMapView *mapView = [[MyTogetherMapView alloc]initWithNibName:@"DetailTogetherMapView" bundle:nil];
        if(indexPath.row==2)
        {
            mapView.SelectType=@"departure";
            mapView.DataDict=myTogether;
            [myTogetherViewController presentModalViewController:mapView animated:YES];
        }
        else if(indexPath.row==3)
        {
            mapView.SelectType=@"destination";
            mapView.DataDict=myTogether;
            [myTogetherViewController presentModalViewController:mapView animated:YES];
        }
        else if ( indexPath.row == 5 )
        {
            //NSLog(@"viewParticipants");
            if([networkHandler isNetworkReachableWithAlert:YES]){
                
                MyTogetherParticipantsViewController* participantsView = [[MyTogetherParticipantsViewController alloc] initWithNibName:@"MyTogetherParticipantsView" bundle:nil];
                participantsView.togetherId = (NSString*)[myTogether objectForKey:@"id"];
                participantsView.listOfParticipants = [myTogether objectForKey:@"participants"];
                [navigationController pushViewController:participantsView animated:YES];
                [participantsView release];
            }
        }
        [mapView release];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag==0)
    {
        switch (buttonIndex) {
            case 0:
                [self quitTogether];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"MyTogetherViewRefresh" object:nil];
                break;
            case 1:
                break;
            default:
                break;
        }
    }
	
}
@end
