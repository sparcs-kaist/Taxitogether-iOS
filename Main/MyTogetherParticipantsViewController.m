//
//  MyTogetherParticipantsViewController.m
//  TaxiTogether
//
//  Created by Fragarach on 7/26/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import "MyTogetherParticipantsViewController.h"
#import "MyTogetherParticipantsViewCell.h"
#import "Asyncimageview.h"
#import "SBJsonParser.h"


@implementation MyTogetherParticipantsViewController
@synthesize togetherId, listOfParticipants;

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

/*
-(void) getParticipants
{
    NSMutableDictionary *requestDict = [[NSMutableDictionary alloc]init];
    
    [requestDict setObject:[dbHandler.userinfo objectForKey:@"userid"] forKey:@"userid"];
    [requestDict setObject:[dbHandler.userinfo objectForKey:@"key"] forKey:@"key"];
    [requestDict setObject:togetherId forKey:@"together"];
    if([networkHandler isNetworkReachableWithAlert:NO]){
        [networkHandler grabURLInBackground:@"grep/get_participants/" callObject:self requestDict:requestDict method:@"POST" alert:NO];
    }
    
    [requestDict release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSString *responseString =[request responseString];
    //NSLog(responseString);
    SBJsonParser* json = [SBJsonParser alloc];
	NSDictionary *dataString = [json objectWithString:responseString];
    
    if([[dataString objectForKey:@"errorcode"]intValue]==1200)
    {
        listOfParticipants = [dataString objectForKey:@"info"];
        [listOfParticipants retain];    
        [[self tableView] reloadData];
    }
    
    [json release];
}
*/
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
    networkHandler = [NetworkHandler getNetworkHandler];
    dbHandler = [DBHandler getDBHandler];
    net = [networkHandler url];
    device=[[UIDevice alloc]init];
    //[self getParticipants];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"count %d", [listOfParticipants count]);
    return [listOfParticipants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ParticipantsViewCell";
    
    MyTogetherParticipantsViewCell *cell= (MyTogetherParticipantsViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* nib=[[NSBundle mainBundle] loadNibNamed:@"MyTogetherParticipantsViewCell" owner:self options:nil];
        cell=(MyTogetherParticipantsViewCell *)[nib objectAtIndex:0];
        //cell = [[MyTogetherParticipantsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if([[device model]isEqualToString:@"iPhone"])
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled=YES;
    }
    else 
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.userInteractionEnabled=NO;
    }
    cell.photoURL = [[listOfParticipants objectAtIndex:[indexPath row]] objectForKey:@"photo"];
    cell.net = net;
    
    cell.phone.text =[[listOfParticipants objectAtIndex: [indexPath row]] objectForKey:@"phone"];
    cell.userid.text = [[listOfParticipants objectAtIndex: [indexPath row]] objectForKey:@"id"];
    
    UITableViewCell *bgView = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    bgView.backgroundColor= [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    cell.backgroundView=bgView;
    
    NSString* gender = [[listOfParticipants objectAtIndex: [indexPath row]] objectForKey:@"gender"];
    if ( [gender isEqualToString:@"M"] ){
        cell.gender.text = @"남";
    }
    else {
        cell.gender.text = @"여";
    }
    
    [cell loadImage];


    //NSMutableString *staticpath = [[NSMutableString alloc]initWithString: @"static/"];
    //[staticpath appendString:[[listOfParticipants objectAtIndex:[indexPath row]] objectForKey:@"photo"]];
    
    //AsyncImageView *asyncImage = [[AsyncImageView alloc]initWithFrame:cell.photo.frame];
    //[asyncImage loadImageFromURL: [NSURL URLWithString:staticpath relativeToURL:net]];
    //NSLog(@"%@", staticpath);
    //[cell.photo addSubview:asyncImage];
    // Configure the cell...
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
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
    
    selectedPath=indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"전화걸기",@"문자메시지", nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex    
{
    if(!(buttonIndex==[actionSheet cancelButtonIndex]))
    {
        if(buttonIndex==0)
        {
            NSString *pStr=[NSString stringWithFormat:@"tel:%@",
                           [[listOfParticipants objectAtIndex:selectedPath]objectForKey:@"phone"]];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pStr]]; 
        }
        if(buttonIndex==1)
        {
            NSString *pStr=[NSString stringWithFormat:@"sms:%@",
                            [[listOfParticipants objectAtIndex:selectedPath]objectForKey:@"phone"]];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pStr]]; 
        }
        
    }
}

@end
