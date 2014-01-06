//
//  SettingsViewPushTimeViewController.m
//  TaxiTogether
//
//  Created by 정 창제 on 11. 8. 1..
//  Copyright 2011년 KAIST. All rights reserved.
//

#import "SettingsViewPushTimeViewController.h"
#import "NetworkHandler.h"
#import "DBHandler.h"

@implementation SettingsViewPushTimeViewController
@synthesize pushTime,SettingsViewObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title=@"택시시간 알림설정";
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"5분전 알림";
            break;
        case 1:
            cell.textLabel.text=@"10분전 알림";
            break;
        case 2:
            cell.textLabel.text=@"15분전 알림";
            break;   
        case 3:
            cell.textLabel.text=@"20분전 알림";
            break;
        default:
            break;
    }
    if(pushTime.intValue==5&&indexPath.row==0)
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else if(pushTime.intValue==10&&indexPath.row==1)
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else if(pushTime.intValue==15&&indexPath.row==2)
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else if(pushTime.intValue==20&&indexPath.row==3)
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
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
    switch (indexPath.row) {
        case 0:
            pushTime=[NSDecimalNumber decimalNumberWithString:@"5"];
            break;
        case 1:
            pushTime=[NSDecimalNumber decimalNumberWithString:@"10"];
            break;
        case 2:
            pushTime=[NSDecimalNumber decimalNumberWithString:@"15"];
            break;
        case 3:
            pushTime=[NSDecimalNumber decimalNumberWithString:@"20"];
            break;
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    DBHandler *dbHandler=[DBHandler getDBHandler];
    NSDictionary *requestDict=[[NSDictionary alloc]initWithObjectsAndKeys:[dbHandler.userinfo objectForKey:@"userid"],@"userid" ,[dbHandler.userinfo objectForKey:@"key"],@"key",pushTime,@"pushtime",nil];
    
    
    NetworkHandler *networkHandler=[NetworkHandler getNetworkHandler];
    [networkHandler grabURLInBackground:@"setting/change_pushtime/" callObject:SettingsViewObject requestDict:(NSMutableDictionary *)requestDict method:@"POST" alert:YES];
    [requestDict release];
}

@end
