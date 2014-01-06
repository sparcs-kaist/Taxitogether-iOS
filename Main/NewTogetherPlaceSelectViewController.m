//
//  NewTogetherPlaceSelectViewController.m
//  TaxiTogether
//
//  Created by 정 창제 on 11. 8. 3..
//  Copyright 2011년 KAIST. All rights reserved.
//

#import "NewTogetherPlaceSelectViewController.h"
#import "NewTogetherPlaceMapSelection.h"
#import "SBJsonParser.h"

@implementation NewTogetherPlaceSelectViewController
@synthesize lblTitle,DataDict,PlacesArray,SelectType,placeField,mapSelectSwitch,addressField,mapEditButton,queue;
-(IBAction)viewMapSelectView
{
    if(mapSelectSwitch.on==TRUE)
    {
        NewTogetherPlaceMapSelection *mapSelectView = [[NewTogetherPlaceMapSelection alloc] initWithNibName:@"NewTogetherPlaceMapSelection" bundle:nil];
        if([SelectType isEqualToString:@"departure"])
        {
            mapSelectView.navItem.title=@"출발지 선택";
            mapSelectView.DataDict=DataDict;
            mapSelectView.SelectType=SelectType;
        }
        else if([SelectType isEqualToString:@"destination"])
        {
            mapSelectView.navItem.title=@"도착지 선택";
            mapSelectView.DataDict=DataDict;
            mapSelectView.SelectType=SelectType;
        }
        for(int i=0;i<[PlacesArray count];i++)
        {
            [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]textLabel]setTextColor:[UIColor blackColor]];
        }
        [self presentModalViewController:mapSelectView animated:YES];
        
        [mapSelectView release];
    }
}
-(IBAction)loadMapSelectViewFromButton
{
    mapSelectSwitch.on=TRUE;
    [self viewMapSelectView];
}
-(IBAction)reloadAddressField
{
    if([SelectType isEqualToString:@"departure"])
    {
        [self getCurrentAddressWithLatitude:[[DataDict objectForKey:@"depa_lat"]floatValue] Longitude:[[DataDict objectForKey:@"depa_long"]floatValue]];
    }
    else if([SelectType isEqualToString:@"destination"])
    {
        [self getCurrentAddressWithLatitude:[[DataDict objectForKey:@"dest_lat"]floatValue] Longitude:[[DataDict objectForKey:@"dest_long"]floatValue]];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [placeField resignFirstResponder];
    return YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [DataDict retain];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    mapSelectSwitch.on=FALSE;
    if([SelectType isEqualToString:@"departure"])
    {
        lblTitle.text=@"출발지";
        [PlacesArray removeObject:[DataDict objectForKey:@"destination"]];
        if([[DataDict objectForKey:@"departure"] isEqualToString:@"선택해주세요!"])
        {
            placeField.text=@"";
            placeField.placeholder=@"선택해주세요!";
        }
        else
        {
            placeField.text=[DataDict objectForKey:@"departure"];
        }

        if(([[DataDict objectForKey:@"depa_long"]floatValue]!=0||
           [[DataDict objectForKey:@"depa_lat"]floatValue]!=0)&&
           ([DataDict objectForKey:@"depa_long"]!=nil||
           [DataDict objectForKey:@"depa_lat"]!=nil)&&
           (![[DataDict objectForKey:@"depa_lat"]isEqualToString:@""]||
           ![[DataDict objectForKey:@"depa_long"]isEqualToString:@""]))
        {
            mapSelectSwitch.on=TRUE;
            [self getCurrentAddressWithLatitude:[[DataDict objectForKey:@"depa_lat"]floatValue] Longitude:[[DataDict objectForKey:@"depa_long"]floatValue]];
        }
        else
        {
            addressField.placeholder=@"지도정보가 없습니다";
        }
    }
    else if([SelectType isEqualToString:@"destination"])
    {
        lblTitle.text=@"도착지";
        [PlacesArray removeObject:[DataDict objectForKey:@"departure"]];
        if([[DataDict objectForKey:@"destination"] isEqualToString:@"선택해주세요!"])
        {
            placeField.text=@"";
            placeField.placeholder=@"선택해주세요!";
        }
        else
        {
            placeField.text=[DataDict objectForKey:@"destination"];
        }
        if(([[DataDict objectForKey:@"dest_long"]floatValue]!=0||
           [[DataDict objectForKey:@"dest_lat"]floatValue]!=0)&&
           ([DataDict objectForKey:@"dest_long"]!=nil||
           [DataDict objectForKey:@"dest_lat"]!=nil)&&
           (![[DataDict objectForKey:@"dest_lat"]isEqualToString:@""]||
           ![[DataDict objectForKey:@"dest_long"]isEqualToString:@""]))
        {
            mapSelectSwitch.on=TRUE;
            [self getCurrentAddressWithLatitude:[[DataDict objectForKey:@"dest_lat"]floatValue] Longitude:[[DataDict objectForKey:@"dest_long"]floatValue]];
        }
        else
        {
            addressField.placeholder=@"지도정보가 없습니다";
        }
    }    
    [self.tableView reloadData];
    
    [placeField addTarget:self action:@selector(removeCheckBoxWhenTextEdited) forControlEvents:UIControlEventEditingChanged];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadAddressField) name:@"MapSelectionViewDidDisappear" object:nil];
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
    /*
    if (loc_request != nil ){
        if ( ![loc_request isFinished]){
            [loc_request clearDelegatesAndCancel];
        }
        [loc_request release];
    }
    */
    
    [DataDict setObject:[placeField text] forKey:SelectType];
    if(mapSelectSwitch.on==FALSE)
    {
        if([SelectType isEqualToString:@"destination"])
        {
            [DataDict setObject:@"" forKey:@"dest_long"];
            [DataDict setObject:@"" forKey:@"dest_lat"];
        }
        else if([SelectType isEqualToString:@"departure"])
        {
            [DataDict setObject:@"" forKey:@"depa_long"];
            [DataDict setObject:@"" forKey:@"depa_lat"];
        }
    }
    
    [queue cancelAllOperations];

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
    return [PlacesArray count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return @"사전설정";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text=[PlacesArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([SelectType isEqualToString:@"departure"])
    {
        if((([[DataDict objectForKey:@"depa_long"]floatValue]!=0||
           [[DataDict objectForKey:@"depa_lat"]floatValue]!=0)&&
           ([DataDict objectForKey:@"depa_long"]!=nil||
           [DataDict objectForKey:@"depa_lat"]!=nil)&&
           (![[DataDict objectForKey:@"depa_lat"]isEqualToString:@""]||
           ![[DataDict objectForKey:@"depa_long"]isEqualToString:@""]))||
           (![[DataDict objectForKey:@"departure"]isEqualToString:@""]&&
           ![[DataDict objectForKey:@"departure"] isEqualToString:@"선택해주세요!"]))
        {
            selectedRowStr=[[[tableView cellForRowAtIndexPath:indexPath]textLabel]text];
            selectedRowInt=indexPath.row;
            UIAlertView* mapMessage=[[UIAlertView alloc]initWithTitle:@"이미 입력된 정보가 있습니다" message:@"입력하신 정보를 선택하신 것으로\n변경하시겠습니까?" delegate:self cancelButtonTitle:@"예" otherButtonTitles:@"아니요", nil];
            mapMessage.tag=0;
            [mapMessage show];
            [mapMessage release];
            
        }
        else
        {
            placeField.text=[[[tableView cellForRowAtIndexPath:indexPath] textLabel]text];
            selectedRowStr=[[[tableView cellForRowAtIndexPath:indexPath]textLabel]text];
            selectedRowInt=indexPath.row;
            [self setMapLocation];
            [mapSelectSwitch setOn:YES];
            [[[self.tableView cellForRowAtIndexPath:indexPath]textLabel]setTextColor:[UIColor blueColor]];
            [self.tableView reloadData];
        }
    }
    else if([SelectType isEqualToString:@"destination"])
    {
        if((([[DataDict objectForKey:@"dest_long"]floatValue]!=0||
           [[DataDict objectForKey:@"dest_lat"]floatValue]!=0)&&
           ([DataDict objectForKey:@"dest_long"]!=nil||
           [DataDict objectForKey:@"dest_lat"]!=nil)&&
           (![[DataDict objectForKey:@"dest_lat"]isEqualToString:@""]||
           ![[DataDict objectForKey:@"dest_long"]isEqualToString:@""]))||
           (![[DataDict objectForKey:@"destination"]isEqualToString:@""]&&
           ![[DataDict objectForKey:@"destination"] isEqualToString:@"선택해주세요!"]))
        {
            selectedRowStr=[[[tableView cellForRowAtIndexPath:indexPath]textLabel]text];
            selectedRowInt=indexPath.row;
            UIAlertView* mapMessage=[[UIAlertView alloc]initWithTitle:@"사전에 입력된 정보가 있습니다." message:@"입력하신 정보를 선택하신것으로 변경하시겠습니까?" delegate:self cancelButtonTitle:@"예" otherButtonTitles:@"아니요", nil];
            mapMessage.tag=1;
            [mapMessage show];
            [mapMessage release];
        }
        else
        {
            placeField.text=[[[tableView cellForRowAtIndexPath:indexPath] textLabel ]text];
            selectedRowStr=[[[tableView cellForRowAtIndexPath:indexPath]textLabel]text];
            selectedRowInt=indexPath.row;
            [self setMapLocation];
            [mapSelectSwitch setOn:YES];
            [[[self.tableView cellForRowAtIndexPath:indexPath]textLabel]setTextColor:[UIColor blueColor]];
            [self.tableView reloadData];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==0|| alertView.tag==1)
    {
        if(buttonIndex==0)
        {
            [self setMapLocation]; 
            placeField.text=[[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRowInt inSection:0]]textLabel]text];
            for(int i=0;i<[PlacesArray count];i++)
            {
                if(selectedRowInt!=i)
                    [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]textLabel]setTextColor:[UIColor blackColor]];
                else
                    [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRowInt inSection:0]]textLabel]setTextColor:[UIColor blueColor]];
            }
           
            [self.tableView reloadData];
        }
    }
}

-(void)setMapLocation
{
    mapSelectSwitch.on=TRUE;
    if([selectedRowStr isEqualToString:@"대전역"]) {
        if([SelectType isEqualToString:@"departure"])
        {
            [DataDict setObject:[NSString stringWithFormat:@"%f",36.331218334505074f] forKey:@"depa_lat"];
            [DataDict setObject:[NSString stringWithFormat:@"%f",127.43268611744418f] forKey:@"depa_long"];
        }
        else if([SelectType isEqualToString:@"destination"])
        {
            [DataDict setObject:[NSString stringWithFormat:@"%f",36.331218334505074f] forKey:@"dest_lat"];
            [DataDict setObject:[NSString stringWithFormat:@"%f",127.43268611744418f] forKey:@"dest_long"];
        }
        [self getCurrentAddressWithLatitude:36.331218334505074f Longitude:127.43268611744418f];
    }
    else if([selectedRowStr isEqualToString:@"서대전역"])
    {
        if([SelectType isEqualToString:@"departure"])
        {
            [DataDict setObject:[NSString stringWithFormat:@"%f",36.322845f] forKey:@"depa_lat"];
            [DataDict setObject:[NSString stringWithFormat:@"%f", 127.404075f] forKey:@"depa_long"];
        }
        else if([SelectType isEqualToString:@"destination"])
        {
            [DataDict setObject:[NSString stringWithFormat:@"%f",36.322845f] forKey:@"dest_lat"];
            [DataDict setObject:[NSString stringWithFormat:@"%f", 127.404075f] forKey:@"dest_long"];
        }
        [self getCurrentAddressWithLatitude:36.322845f Longitude:127.404075f];
    }
    else if([selectedRowStr isEqualToString:@"택시승강장(기계동)"])
    {
        if([SelectType isEqualToString:@"departure"])
        {
            [DataDict setObject:[NSString stringWithFormat:@"%f",36.372688189129185f] forKey:@"depa_lat"];
            [DataDict setObject:[NSString stringWithFormat:@"%f", 127.35953450202942f] forKey:@"depa_long"];
        }
        else if([SelectType isEqualToString:@"destination"])
        {
            [DataDict setObject:[NSString stringWithFormat:@"%f",36.372688189129185f] forKey:@"dest_lat"];
            [DataDict setObject:[NSString stringWithFormat:@"%f", 127.35953450202942f] forKey:@"dest_long"];
        }
        [self getCurrentAddressWithLatitude:36.372688189129185f Longitude:127.35953450202942f];
    }
    else if([selectedRowStr isEqualToString:@"택시승강장(문지동)"])
    {
        if([SelectType isEqualToString:@"departure"])
        {
            [DataDict setObject:[NSString stringWithFormat:@"%f",36.392483f] forKey:@"depa_lat"];
            [DataDict setObject:[NSString stringWithFormat:@"%f", 127.399486f] forKey:@"depa_long"];
        }
        else if([SelectType isEqualToString:@"destination"])
        {
            [DataDict setObject:[NSString stringWithFormat:@"%f",36.392483f] forKey:@"dest_lat"];
            [DataDict setObject:[NSString stringWithFormat:@"%f", 127.399486f] forKey:@"dest_long"];
        }
        [self getCurrentAddressWithLatitude:36.392483f Longitude:127.399486f];
    }

    else if([selectedRowStr isEqualToString:@"둔산동"])
    {
        if([SelectType isEqualToString:@"departure"])
        {
            [DataDict setObject:[NSString stringWithFormat:@"%f",36.351313338625388f] forKey:@"depa_lat"];
            [DataDict setObject:[NSString stringWithFormat:@"%f", 127.37849503755569f] forKey:@"depa_long"];
        }
        else if([SelectType isEqualToString:@"destination"])
        {
            [DataDict setObject:[NSString stringWithFormat:@"%f",36.351313338625388f] forKey:@"dest_lat"];
            [DataDict setObject:[NSString stringWithFormat:@"%f", 127.37849503755569f] forKey:@"dest_long"];
        }
        [self getCurrentAddressWithLatitude:36.351313338625388f Longitude:127.37849503755569f];
    }
    else if([selectedRowStr isEqualToString:@"유성시외버스터미널"])
    {
        if([SelectType isEqualToString:@"departure"])
        {
            [DataDict setObject:[NSString stringWithFormat:@"%f",36.355610784901607f] forKey:@"depa_lat"];
            [DataDict setObject:[NSString stringWithFormat:@"%f", 127.3359927669855f] forKey:@"depa_long"];
        }
        else if([SelectType isEqualToString:@"destination"])
        {
            [DataDict setObject:[NSString stringWithFormat:@"%f",36.355610784901607f] forKey:@"dest_lat"];
            [DataDict setObject:[NSString stringWithFormat:@"%f", 127.3359927669855f] forKey:@"dest_long"];
        }
         [self getCurrentAddressWithLatitude:36.355610784901607f Longitude:127.3359927669855f];
     }
    else if([selectedRowStr isEqualToString:@"유성금호고속버스터미널"])
    {
        if([SelectType isEqualToString:@"departure"])
        {
            [DataDict setObject:[NSString stringWithFormat:@"%f",36.359915f] forKey:@"depa_lat"];
            [DataDict setObject:[NSString stringWithFormat:@"%f", 127.336229f] forKey:@"depa_long"];
        }
        else if([SelectType isEqualToString:@"destination"])
        {
            [DataDict setObject:[NSString stringWithFormat:@"%f",36.359915f] forKey:@"dest_lat"];
            [DataDict setObject:[NSString stringWithFormat:@"%f", 127.336229f] forKey:@"dest_long"];
        }
         [self getCurrentAddressWithLatitude:36.359915f Longitude:127.336229f];
     }
     else if([selectedRowStr isEqualToString:@"동부시외버스터미널"])
     {
         if([SelectType isEqualToString:@"departure"])
         {
             [DataDict setObject:[NSString stringWithFormat:@"%f",36.349795073024218f] forKey:@"depa_lat"];
             [DataDict setObject:[NSString stringWithFormat:@"%f", 127.44069869304263f] forKey:@"depa_long"];
         }
         else if([SelectType isEqualToString:@"destination"])
         {
             [DataDict setObject:[NSString stringWithFormat:@"%f",36.349795073024218f] forKey:@"dest_lat"];
             [DataDict setObject:[NSString stringWithFormat:@"%f", 127.44069869304263f] forKey:@"dest_long"];
         }
        [self getCurrentAddressWithLatitude:36.349795073024218f Longitude:127.44069869304263f];
     }
     else if([selectedRowStr isEqualToString:@"정부청사시외버스터미널"])
     {
         if([SelectType isEqualToString:@"departure"])
         {
             [DataDict setObject:[NSString stringWithFormat:@"%f",36.361673f] forKey:@"depa_lat"];
             [DataDict setObject:[NSString stringWithFormat:@"%f", 127.379855f] forKey:@"depa_long"];
         }
         else if([SelectType isEqualToString:@"destination"])
         {
             [DataDict setObject:[NSString stringWithFormat:@"%f",36.361673f] forKey:@"dest_lat"];
             [DataDict setObject:[NSString stringWithFormat:@"%f", 127.379855f] forKey:@"dest_long"];
         }
         [self getCurrentAddressWithLatitude:36.361673f Longitude:127.379855f];
     }
     
}

-(IBAction)removeCheckBoxWhenTextEdited  
{
    for(int i=0;i<[PlacesArray count];i++)
    {
        [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]textLabel]setTextColor:[UIColor blackColor]];
    }
    [self.tableView reloadData];
}

-(void)getCurrentAddressWithLatitude:(float)lat Longitude:(float)lon
{
    if(![self queue])
    {
        [self setQueue:[[NSOperationQueue alloc]init]];
    }
    NSString *fetchURL = [NSString stringWithFormat:@"http://maps.google.co.kr/maps/geo?q=%@,%@&language=ko&output=json&sensor=true", 
                          [NSString stringWithFormat:@"%f",lat], 
                          [NSString stringWithFormat:@"%f",lon]];
    
    ASIFormDataRequest *loc_request = [ASIFormDataRequest requestWithURL:[[[NSURL alloc] initWithString:fetchURL]autorelease]];
    //[loc_request retain];
    [loc_request setShouldAttemptPersistentConnection:NO];
    [loc_request setRequestMethod:@"GET"];
    [loc_request setDelegate:self];
    [loc_request setTimeOutSeconds:4.0];
    [loc_request setDidFinishSelector:@selector(requestFinished:)];
    [loc_request setDidFailSelector:@selector(requestFailed:)];
    [[self queue] addOperation:loc_request]; //queue is an NSOperationQueue
}
    
- (IBAction)requestFailed:(ASIHTTPRequest *)request {
    addressField.placeholder = @"주소 가져오기에 실패하였습니다.";
}

- (IBAction)requestFinished:(ASIHTTPRequest *)request
{
    
    NSString *htmlData =[request responseString];
    NSString *currentAddress; 
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *json = [parser objectWithString:htmlData];
    NSArray *placemark = [json objectForKey:@"Placemark"];
    currentAddress=[[placemark objectAtIndex:0]objectForKey:@"address"];
    
    [parser release];
    
    NSString *address;
    NSRange rangeOfSubstring = [currentAddress rangeOfString:@"대한민국 "];
    
    if(rangeOfSubstring.location == NSNotFound)
    {
        address=currentAddress;
    }
    else
    {
        address=[currentAddress substringFromIndex:rangeOfSubstring.location+5];
    }
    
    addressField.placeholder=address;
}


@end
