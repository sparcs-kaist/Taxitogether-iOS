//
//  MainAppDelegate.m
//  Main
//
//  Created by Jay on 11. 6. 10..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainAppDelegate.h"
#import "NetworkHandler.h"      
#import "DBHandler.h"
#import "TogetherListTableViewController.h"
#import "NetworkHandler.h"
#import "SBJsonParser.h"
@implementation MainAppDelegate


@synthesize window=_window;
@synthesize deviceId;

@synthesize tabBarController=_tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [self checkNotice];
    [self checkVersion];
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 
{ 
    deviceId = [[NSMutableString alloc]init]; 
    const unsigned char* ptr = (const unsigned char*) [deviceToken bytes]; 
    
    for(int i = 0 ; i < 32 ; i++) 
    { 
        [deviceId appendFormat:@"%02x", ptr[i]]; 
    } 
    
    //NSLog(@"APNS Device Token: %@", deviceId); 
} 

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

    NSMutableArray *apsKeys = [[NSMutableArray alloc] initWithArray:[[userInfo objectForKey:@"aps"] allKeys]];
    if ( [apsKeys containsObject:@"userid"] && [apsKeys containsObject:@"key"] )
    {
        //NSLog(@"update start");
        NSMutableDictionary *aps = [userInfo objectForKey:@"aps"];
        DBHandler *dbHandler = [DBHandler getDBHandler];
        [dbHandler updateUserInfo:[aps objectForKey:@"userid"] withKey:[aps objectForKey:@"key"]];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"VerificationPush" object: self];
    }

    
    [[[[UIAlertView alloc] initWithTitle:@"알림" message:[[userInfo objectForKey:@"aps"]objectForKey:@"alert"] delegate:nil
                                                  cancelButtonTitle:@"확인" otherButtonTitles:nil, nil]autorelease]show];
    [apsKeys release];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    NetworkHandler *networkHandler=[NetworkHandler getNetworkHandler];
    [[networkHandler queue]cancelAllOperations];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    DBHandler *dbHandler=[DBHandler getDBHandler];
    if(![[dbHandler.userinfo objectForKey:@"userid"]isEqualToString:@""]||![[dbHandler.userinfo objectForKey:@"key"]isEqualToString:@""])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillEnterForeground" object:nil];
    }
    
    [self checkNotice];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{

}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

-(void)checkNotice
{
    NetworkHandler *networkHandler=[NetworkHandler getNetworkHandler];
    
    [networkHandler grabURLInBackground:@"grep/notification/" callObject:self requestDict:nil method:@"POST" alert:NO];
}

-(void)checkVersion
{
    NetworkHandler *networkHandler=[NetworkHandler getNetworkHandler];
    
    [networkHandler grabURLInBackground:@"grep/version/" callObject:self requestDict:nil method:@"GET" alert:NO];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString =[request responseString];
    //NSLog(responseString);
    SBJsonParser* json = [SBJsonParser alloc];
	NSDictionary *dataString = [json objectWithString:responseString];
    int errorcode = [[dataString objectForKey:@"errorcode"]intValue];
    
    [json release]; 
    
    if(errorcode==1200){
        return;
    }
    else if(errorcode==1201){
        
        NSArray *paths = [[NSArray alloc] initWithArray:(NSArray*) NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)];
        NSString *documentsDirectory = [[NSString alloc] initWithString:(NSString *)[paths objectAtIndex:0]];
        NSString *fileName = [[NSString alloc] initWithString:(NSString *)@"noticeTagList"];
        NSString *filePath = [[NSString alloc] initWithString:(NSString *)[documentsDirectory stringByAppendingPathComponent:fileName]];
       
        tag=[[NSString alloc]initWithString:[dataString objectForKey:@"tag"]];
        FILE* file=fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "r");
        
        if(file==NULL)
        {
            file=fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding],"w");
            fclose(file);
            file=fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "r");
        }
    
        /*[paths release];
        [documentsDirectory release];
        [filePath release];
        */
        
        char buf[30];
        fgets(buf, sizeof(buf), file);
        
        fclose(file);
        if([[NSString stringWithCString:buf encoding:NSUTF8StringEncoding]isEqualToString:tag])
        {
            return;
        }
        else 
        {
            [[[[UIAlertView alloc]initWithTitle:@"공지사항" message:[dataString objectForKey:@"notice"] delegate:self cancelButtonTitle:@"다시보지않기" otherButtonTitles:@"확인", nil]autorelease]show];
        }
    }
    else if(errorcode==1300)
    {
        NSString *versionInfo = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"];
        if([[dataString objectForKey:@"version"]floatValue]!=[versionInfo floatValue])
        {
            NSString *versionString = [NSString stringWithFormat:@"%@버전이 출시되었습니다. \n앱을 업데이트 해주세요!",[dataString objectForKey:@"version"]];
            [[[[UIAlertView alloc]initWithTitle:@"업데이트" message:versionString delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil]autorelease]show];
            
        }
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  
{
    if(buttonIndex==0)
    {
        NSArray *paths = [[NSArray alloc] initWithArray:(NSArray*) NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)];
        NSString *documentsDirectory = [[NSString alloc] initWithString:(NSString *)[paths objectAtIndex:0]];
        NSString *fileName = [[NSString alloc] initWithString:(NSString *)@"noticeTagList"];
        NSString *filePath = [[NSString alloc] initWithString:(NSString *)[documentsDirectory stringByAppendingPathComponent:fileName]];
        
        FILE* file=fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "w");
    
        
        [paths release];
        [documentsDirectory release];
        [filePath release];

        fputs([tag UTF8String], file);
    
        fclose(file);
    }
    
}
@end
