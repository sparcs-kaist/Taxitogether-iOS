//
//  SettingsViewController.m
//  TaxiTogether
//
//  Created by Fragarach on 7/30/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsViewCellController.h"
#import "DBHandler.h"
#import "SBJsonParser.h"
#import "NetworkHandler.h"
#import "Asyncimageview.h"
#import "ASIFormDataRequest.h"
#import "SettingsViewPushTimeViewCell.h"
#import "SettingsViewPushTimeViewController.h"
#import "SettingsViewHelpWebView.h"
#import "SettingsViewVersionInfoViewController.h"


@implementation SettingsViewController
@synthesize header, profileImage, profileImageButton, ProgressView, largeProgressView;

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

-(IBAction) changeProfileImage
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIActionSheet *actionSheetNonCamera=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"사진앨범에서 선택", nil];
        actionSheetNonCamera.tag=0;
        [actionSheetNonCamera setActionSheetStyle:UIActionSheetStyleDefault];
        [actionSheetNonCamera showFromTabBar:self.tabBarController.tabBar];
        [actionSheetNonCamera release];
    }
    else{
        UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"사진촬영",@"사진앨범에서 선택", nil];
        actionSheet.tag=1;
        [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        [actionSheet release];
    }
}
-(IBAction) selectExistingPicture
{
    //NSLog(@"chagne profile image");
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
	[self presentModalViewController:picker animated:YES];
}

-(IBAction) getCameraPicture
{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    picker.allowsEditing=YES;
    picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    [self presentModalViewController:picker animated:YES];
    [picker release];
    
}

-(void) requestForProfile
{
    self.navigationItem.leftBarButtonItem.enabled = NO;
    asyncProfileView.hidden = YES;
    largeProgressView.center=CGPointMake(160, self.tableView.contentOffset.y+190);
    [self.view addSubview:largeProgressView];
    [self.view setUserInteractionEnabled:FALSE];
    NetworkHandler* networkHandler = [NetworkHandler getNetworkHandler];
    DBHandler *dbHandler=[DBHandler getDBHandler];
    
    NSMutableDictionary *requestDict=[[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                       [dbHandler.userinfo objectForKey:@"userid"],@"userid",
                                       [dbHandler.userinfo objectForKey:@"key"],@"key",
                                       nil]autorelease];
    
    [networkHandler grabURLInBackground:@"grep/get_my_profile/" callObject:self requestDict:requestDict method:@"POST" alert:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
    //NSLog(@"I am here");

    // Set the image for the image managed object.
    //UIImage *selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *selectedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];	
    
    // Create a thumbnail version of the image for the recipe object.
    CGSize size = selectedImage.size;
    CGFloat ratio = 0;
    if (size.width > size.height) {
        ratio = 200 / size.width;
    } else {
        ratio = 200 / size.height;
    }
    CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    [selectedImage drawInRect:rect];

        //NSLog(@"asyncProfileView");
    
    NetworkHandler* networkHandler = [NetworkHandler getNetworkHandler];
    DBHandler *dbHandler=[DBHandler getDBHandler];
    
    NSMutableDictionary *requestDict=[[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                       [dbHandler.userinfo objectForKey:@"userid"],@"userid",
                                       [dbHandler.userinfo objectForKey:@"key"],@"key",
                                       nil]autorelease];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[networkHandler url] URLByAppendingPathComponent:@"setting/change/"]];
    [request setShouldAttemptPersistentConnection:NO];
    
    for(int i=0;i<[requestDict count];i++)
    {
        [request setPostValue:[requestDict objectForKey:[[requestDict allKeys] objectAtIndex:i]] 
                       forKey:[[requestDict allKeys] objectAtIndex:i]];
    }
    [request setData:UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext()) 
        withFileName:@"a.png" andContentType:@"image/png" forKey:@"photo"];
    UIGraphicsEndImageContext();
    [request setDelegate:self];
    [request startAsynchronous];

    //[profileImage setImage:UIGraphicsGetImageFromCurrentImageContext()];
    //profileImage.image = UIGraphicsGetImageFromCurrentImageContext();
	//profileImage.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
 
    NSString *responseString =[request responseString];
    //NSLog(responseString);
    SBJsonParser* json = [SBJsonParser alloc];
	NSDictionary *dataString = [json objectWithString:responseString];
    
    int errorcode = [[dataString objectForKey:@"errorcode"]intValue];
    
    if(errorcode==1100)
    {
        //NSLog(@"AAAAA");
        profile = [dataString objectForKey:@"info"];
        [profile retain];
        pushTime=[profile objectForKey:@"pushtime"];
        NSMutableString *staticpath = [[NSMutableString alloc]initWithString: @"static/"];
        [staticpath appendString:[profile objectForKey:@"photo"]];
        
        [asyncProfileView loadImageFromURL: [NSURL URLWithString:staticpath relativeToURL:net]];
        
        self.ProgressView.hidden = NO;
        [self.profileImageButton setUserInteractionEnabled:FALSE];
        [self.tableView reloadData];
        [staticpath release];
    }
    else if(errorcode==1001)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류!" message:@"사용자정보가 존재하지 않습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if ( errorcode == 200 )
    {
        //NSLog(@"Reqeust 200-2 profile");
        [self requestForProfile];
    }
    else if ( errorcode == 201)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류!" message:@"푸시알림시간이 올바르지 않습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if ( errorcode == 202)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류!" message:@"심각한 오류가 발생하였습니다. 앱을 재설치하여 재인증을 받아주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else if ( errorcode  == 205 )
    {
        pushTime=[dataString objectForKey:@"pushtime"];
        [pushTime retain];
        [self.tableView reloadData];
    }
    else if ( errorcode == 206)
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류!" message:@"올바르지 않은 내용입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    }
    else
    {
        [[[[UIAlertView alloc]initWithTitle:@"오류" message:[NSString stringWithFormat:@"(%@)개발자에게 문의해주세요",[dataString objectForKey:@"errorcode"]] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease ]show];
    }
    [[self largeProgressView] removeFromSuperview];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [self.view setUserInteractionEnabled:YES];
    
    [json release];
}



- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    if ([error code] == ASIRequestTimedOutErrorType && self.tabBarController.selectedIndex == 3 ) {
        // Actions specific to timeout
        [[[[UIAlertView alloc]initWithTitle:@"네트워크 오류" message:@"RequestTimeOut.\n다시 시도해 보세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];   
    }
    [[self largeProgressView] removeFromSuperview];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [self.view setUserInteractionEnabled:YES];
    
}

-(void) removeProgressViewWithSuccess
{
    //NSLog(@"HELLO SUCCESS");
    ProgressView.hidden = YES;
    asyncProfileView.hidden= NO;
    [self.profileImageButton setUserInteractionEnabled:YES];
}

-(void) removeProgressViewWithFail
{
    //NSLog(@"HELLO FAIL");
    NSMutableString *staticpath = [[NSMutableString alloc]initWithString: @"static/"];
    [staticpath appendString:[profile objectForKey:@"photo"]];
    [asyncProfileView loadImageFromURL: [NSURL URLWithString:staticpath relativeToURL:net]];
    [staticpath release];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   // UIBarButtonItem *RefreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh                                                                                   target:self action:@selector(refreshMyProfile)];
   // aNavigationItem.leftBarButtonItem = RefreshButton;

    net = [[NetworkHandler getNetworkHandler] url];
    UIBarButtonItem *RefreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(requestForProfile)];
    self.navigationItem.leftBarButtonItem = RefreshButton;
    [RefreshButton release];
    
    asyncProfileView = [[[AsyncImageView alloc]initWithFrame:
                         CGRectMake(0, 0, profileImage.frame.size.width, profileImage.frame.size.height)] autorelease];
    [profileImage addSubview:asyncProfileView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressViewWithSuccess) 
                                                 name:@"ProfileImageSuccess" object:asyncProfileView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressViewWithFail) 
                                                 name:@"ProfileImageFail" object:asyncProfileView];
    [self requestForProfile];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 5;
        case 1:
            return 1;
        case 2:
            return 3;
        default:
            return 0;
    } 
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0){
        return @"프로필";
    }
    else if (section==1){
        return @"푸시알림 시간 설정";
    }
    else if(section==2){
        return nil;
    }
    else {
        return @"NON";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingsViewCell";
    static NSString *kCellIdentifier = @"ViewCell";
    static NSString *mailCellIdentifier=@"MailCell";
    if ( [indexPath section] == 0 ){
        SettingsViewCellController *cell= (SettingsViewCellController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray* nib=[[NSBundle mainBundle] loadNibNamed:@"SettingsViewCell" owner:self options:nil];
            cell=(SettingsViewCellController *)[nib objectAtIndex:0];
            cell.accessoryType=UITableViewCellAccessoryNone;
        }   
    
        switch ([indexPath row]) {
            case 0:
                cell.title.text= @"아이디";
                cell.desc.text = [profile objectForKey:@"userid"];
                break;
            case 1:
                cell.title.text = @"성별";
                NSString *gender = [profile objectForKey:@"gender"];
                if ( [gender isEqualToString:@"M"] )
                {
                    cell.desc.text = @"남";
                }
                else if( [gender isEqualToString:@"F"] )
                {
                    cell.desc.text = @"여";
                }
                break;
            case 2:
                cell.title.text = @"전화번호";
                cell.desc.text = [profile objectForKey:@"phone"];
                break;
            case 3:
                cell.title.text = @"인증시간";
                cell.desc.text = [profile objectForKey:@"registertime"];
                break;
            case 4:
                cell.title.text= @"버전정보";
                cell.desc.text = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"];
                cell.userInteractionEnabled=TRUE;
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
        return cell;
    }
    else if ([indexPath section]==1){
        SettingsViewPushTimeViewCell *cell=(SettingsViewPushTimeViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if(cell==nil)
        {
            NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"SettingsViewPushTimeViewCell" owner:self options:nil];
            cell=(SettingsViewPushTimeViewCell *)[nib objectAtIndex:0];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.pushTime.text=[NSString stringWithFormat:@"%@ 분전 알림",pushTime];
        return cell;
    }
    else if ([indexPath section]==2)
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:mailCellIdentifier];
        if(cell==nil)
        {
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mailCellIdentifier]autorelease];
        }
        if(indexPath.row==0)
        {
            cell.textLabel.text=@"공지사항/사용설명서/개발자정보";
            cell.textLabel.textAlignment=UITextAlignmentCenter;
        }
        else if(indexPath.row==1)
        {
            cell.textLabel.text=@"개발자에게 메일 보내기";
            cell.textLabel.textAlignment=UITextAlignmentCenter;
        }
        else if(indexPath.row==2)
        {
            cell.textLabel.text=@"택시투게더 블로그 가기";
            cell.textLabel.textAlignment=UITextAlignmentCenter;
        }
        return cell;
    }
    return nil;
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
    if(indexPath.section==0)
    {
        if(indexPath.row==4)
        {
            SettingsViewVersionInfoViewController *versionView = [[SettingsViewVersionInfoViewController alloc]initWithNibName:@"SettingsViewVersionInfoViewController" bundle:nil];
            [self.navigationController pushViewController:versionView animated:YES];
        }
    }
    else if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            SettingsViewPushTimeViewController *pushTimeView=[[SettingsViewPushTimeViewController alloc]initWithNibName:@"SettingsViewPushTimeViewController" bundle:nil];
            pushTimeView.pushTime=pushTime;
            pushTimeView.SettingsViewObject=self;
            [self.navigationController pushViewController:pushTimeView animated:YES];
            [pushTimeView release];
        }
    }
    if(indexPath.section==2)
    {
        if(indexPath.row==0)
        {
            SettingsViewHelpWebView *webView=[[[SettingsViewHelpWebView alloc]initWithNibName:@"SettingsViewHelpWebView" bundle:nil]autorelease];
            [self presentModalViewController:webView animated:YES];
        }
        else if(indexPath.row==1)
        {
            DBHandler *dbHandler = [DBHandler getDBHandler];
            NSString *sender = [NSString stringWithFormat:@"(%@)", [dbHandler.userinfo objectForKey:@"userid"]];
            NSString *pStr = 
            [[NSString stringWithFormat:
              @"mailto://taxitogether@sparcs.org?&subject=To:택시투게더 개발자에게 %@", sender]
             stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            // openURL 로 링크 실행
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pStr]]; 

        }
        else if (indexPath.row == 2)
        {
            NSString *blog = @"http://taxitogether.tistory.com";
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:blog]];
        }
    }
}
#pragma mark - ActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex    
{
    if(actionSheet.tag==0)
    {
        if(!(buttonIndex==[actionSheet cancelButtonIndex]))
        {
            if(buttonIndex==0)
            {
                [self selectExistingPicture];
            }            
        }
    }
    else if(actionSheet.tag==1)
    {
        if(!(buttonIndex==[actionSheet cancelButtonIndex]))
        {
            if(buttonIndex==0)
            {
                [self getCameraPicture];
            }
            if(buttonIndex==1)
            {
                [self selectExistingPicture];
            }
        
        }
    }
}
@end
