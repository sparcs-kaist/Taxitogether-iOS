//
//  NewTogetherTableViewController.m
//  TaxiTogether
//
//  Created by 정 창제 on 11. 7. 9..
//  Copyright 2011년 KAIST. All rights reserved.
//

#import "NewTogetherTableViewController.h"
#import "NewTogetherViewCellTime.h"
#import "NewTogetherViewCell.h"
#import "NewTogetherPlaceSelectViewController.h"
#import "NetworkHandler.h"
#import "SBJsonParser.h"
#import "NewTogetherPlaceTextInputViewController.h"
#import "NewTogetherCapacitySelectViewController.h"
#import "NewTogetherTimeSelectViewConrtoller.h"
#import "NewTogetherDescriptionInputViewController.h"
#import "DBHandler.h"


@implementation NewTogetherTableViewController
@synthesize tableView,Date,NewTogetherDataDict;
-(IBAction)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)registerNewTogether{
   
    if([[NewTogetherDataDict objectForKey:@"departure"] isEqualToString:@"선택해주세요!"]||
       [[NewTogetherDataDict objectForKey:@"departure"] isEqualToString:@""]||
       [[NewTogetherDataDict objectForKey:@"destination"] isEqualToString:@"선택해주세요!"]||
       [[NewTogetherDataDict objectForKey:@"destination"] isEqualToString:@""]
       )
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"내용을 입력하세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else{
        DBHandler *dbHandler=[DBHandler getDBHandler];
        [NewTogetherDataDict setObject:[dbHandler.userinfo objectForKey:@"userid"] forKey:@"userid"];
        [NewTogetherDataDict setObject:[dbHandler.userinfo objectForKey:@"key"] forKey:@"key"];
        NetworkHandler* networkHandler=[NetworkHandler getNetworkHandler];
        NSDateFormatter* registerDateFormat=[[NSDateFormatter alloc]init];
        [registerDateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        [NewTogetherDataDict setObject:[registerDateFormat stringFromDate:[NewTogetherDataDict objectForKey:@"departtime"]] forKey:@"departtime"];
        indicator =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center=self.view.center;
        [self.view addSubview:indicator];
        [indicator startAnimating];
        
        [networkHandler grabURLInBackground:@"together/create/" callObject:self requestDict:NewTogetherDataDict method:@"POST" alert:YES];
        [registerDateFormat release];
    }
}   

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString =[request responseString];
    ////NSLog(responseString);
    SBJsonParser* json = [SBJsonParser alloc];
	NSDictionary *dataString = [json objectWithString:responseString];
    [indicator stopAnimating];
    [indicator release];
    [json release];
    int errorcode = [[dataString objectForKey:@"errorcode"]intValue];
    if(errorcode==300){
        [[[[UIAlertView alloc]
           initWithTitle:nil message:@"정상 등록되었습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]
         show];
        //[self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"RequestTogetherListToRefresh" object: nil];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"MyTogetherViewRefresh" object:nil];
    }
    else if(errorcode==301)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"이미 지난 시간입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==302)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"1주일 보다 먼 시간을 선택하셨습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==303)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"심각한 오류입니다. 개발자에게 메일로 문의해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==304)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"내용이 모두 입력되지 않았습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==305){
       // [self.navigationController popToRootViewControllerAnimated:YES];
        [[[[UIAlertView alloc]
           initWithTitle:@"오류" message:@"이미 투게더가 있습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"RequestTogetherListToRefresh" object: nil];
    }
    else if(errorcode==306)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"잘못된 날짜 형식입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==307)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"최대인원이 올바르지 않습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==308)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:@"수용인원이 올바르지 않습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if(errorcode==1000){
        
    }
    else if(errorcode==1001){
        //[self.navigationController popToRootViewControllerAnimated:YES];
        [[[[UIAlertView alloc]initWithTitle:@"알림!" message:@"이미 속해있는 투게더가 있습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease ]show]; 
    }
    else if(errorcode==1002){
        
    }
    else
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:[NSString stringWithFormat:@"(%@)개발자에게 문의해주세요",[dataString objectForKey:@"errorcode"]] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease ]show];
    }
    
}
    
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    if ([error code] == ASIRequestTimedOutErrorType && self.tabBarController.selectedIndex == 0 ) {
        // Actions specific to timeout
        [[[[UIAlertView alloc]initWithTitle:@"네트워크 오류" message:@"RequestTimeOut.\n다시 시도해 보세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
        
    }
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization 
        Today = [NSDate date];
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:Today];
        
        NSInteger remainder = [dateComponents minute] % 5; // gives us the remainder when divided by 5 (for example, 25 would be 0, but 23 
        Today = [Today dateByAddingTimeInterval:((5 - remainder) * 60)]; // Add the difference
        
        // Subtract the number of seconds
        Today = [Today dateByAddingTimeInterval:(-1 * [dateComponents second])];
        
        
        PlacesArray=[[NSMutableArray alloc]initWithObjects:@"택시승강장(기계동)",@"택시승강장(문지동)",@"대전역",@"서대전역",@"둔산동",@"유성시외버스터미널",@"유성금호고속버스터미널",@"동부시외버스터미널",@"정부청사시외버스터미널", nil];
        
        DateFormat=[[NSDateFormatter alloc]init];
        Departure=[[NSString alloc]initWithString:@"선택해주세요!"];
        Destination=[[NSString alloc]initWithString:@"선택해주세요!"];
        
        [DateFormat setWeekdaySymbols:[[[NSArray alloc] initWithObjects:@"일",@"월",@"화",@"수",@"목",@"금",@"토", nil]autorelease]];
        [DateFormat setAMSymbol:@"오전"];
        [DateFormat setPMSymbol:@"오후"];
        [DateFormat setDateFormat:@"MM/dd(ccc) aa hh:mm"];
        
        NewTogetherDataDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:Today,@"departtime", nil];
        [NewTogetherDataDict setObject:Departure forKey:@"departure"];
        [NewTogetherDataDict setObject:Destination forKey:@"destination"];
        [NewTogetherDataDict setObject:@"4" forKey:@"capacity"];
        [NewTogetherDataDict setObject:@"" forKey:@"description"];
        
        self.navigationItem.title=@"새로운 투게더";
        UIBarButtonItem *btOK = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(registerNewTogether)];
        self.navigationItem.rightBarButtonItem=btOK;
        [btOK release];
        
        UIBarButtonItem *btCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(popView)];
        self.navigationItem.leftBarButtonItem=btCancel;
        [btCancel release];
        
        ListTitles=[[NSArray alloc]initWithObjects:@"출발지",@"도착지",@"최대인원",@"날짜&시간",@"설명", nil];
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
    //NSLog(@"Today : %@",[Today description]);
    //NSLog(@"NewTogetherDataDict Today: %@",[[NewTogetherDataDict objectForKey:@"departtime"]description]);
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
    [self.tableView  reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"새투게더 만들기";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}


/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 40;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomID";
    NewTogetherViewCell* cell=(NewTogetherViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        NSArray* nib=[[NSBundle mainBundle] loadNibNamed:@"NewTogetherViewCell" owner:self options:nil];
        cell=(NewTogetherViewCell *)[nib objectAtIndex:0];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.Title.text=[ListTitles objectAtIndex:indexPath.row];
    if(indexPath.row==0)
        cell.Content.text=[NewTogetherDataDict objectForKey:@"departure"];
    else if(indexPath.row==1)
        cell.Content.text=[NewTogetherDataDict objectForKey:@"destination"];
    else if(indexPath.row==2)
        cell.Content.text=[NewTogetherDataDict objectForKey:@"capacity"];
    else if(indexPath.row==3)
        cell.Content.text=[DateFormat stringFromDate:[NewTogetherDataDict objectForKey:@"departtime"]];
    else if(indexPath.row==4)
        cell.Content.text=[NewTogetherDataDict objectForKey:@"description"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row==0){
        NewTogetherPlaceSelectViewController* PlaceSelect=[[[NewTogetherPlaceSelectViewController alloc]initWithNibName:@"NewTogetherPlaceSelectViewController" bundle:nil]autorelease];
        PlaceSelect.DataDict=NewTogetherDataDict;
        PlaceSelect.PlacesArray=[NSMutableArray arrayWithArray:PlacesArray];
        PlaceSelect.SelectType=@"departure";
        [self.navigationController pushViewController:PlaceSelect animated:YES];
    }
    else if(indexPath.row==1){
        NewTogetherPlaceSelectViewController* PlaceSelect=[[[NewTogetherPlaceSelectViewController alloc]initWithNibName:@"NewTogetherPlaceSelectViewController" bundle:nil]autorelease];
        PlaceSelect.DataDict=NewTogetherDataDict;
        PlaceSelect.PlacesArray=[NSMutableArray arrayWithArray:PlacesArray];
        PlaceSelect.SelectType=@"destination";
        [self.navigationController pushViewController:PlaceSelect animated:YES];
    }
    else if(indexPath.row==2){
        NewTogetherCapacitySelectViewController* CapacitySelect=[[[NewTogetherCapacitySelectViewController alloc]initWithNibName:@"NewTogetherCapacitySelectViewController" bundle:nil]autorelease];
        //NewTogetherCapacitySelectViewController *CapacitySelect =[[[NewTogetherCapacitySelectViewController alloc]init]autorelease];
        CapacitySelect.NewTogetherDataDict=NewTogetherDataDict;
        [self.navigationController pushViewController:CapacitySelect animated:YES];
    }
    else if(indexPath.row==3){
        NewTogetherTimeSelectViewConrtoller* TimeSelect=[[[NewTogetherTimeSelectViewConrtoller alloc]init]autorelease];
        TimeSelect.DataDict=NewTogetherDataDict;
        [self.navigationController pushViewController:TimeSelect animated:YES];
    }
    else if(indexPath.row==4){
        NewTogetherDescriptionInputViewController* DescriptionInput=[[[NewTogetherDescriptionInputViewController alloc]init]autorelease];
        DescriptionInput.NewTogetherDataDict=NewTogetherDataDict;
        DescriptionInput.textView.text=[NewTogetherDataDict objectForKey:@"description"];
        [self.navigationController pushViewController:DescriptionInput animated:YES];
    }
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
