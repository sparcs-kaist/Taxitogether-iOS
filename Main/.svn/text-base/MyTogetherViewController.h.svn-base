//
//  MyTogetherViewController.h
//  TaxiTogether
//
//  Created by Fragarach on 7/24/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJsonParser.h"
#import "NetworkHandler.h"
#import "DBHandler.h"
#import "MyTogetherHeaderViewController.h"

@interface MyTogetherViewController : UITableViewController  {

    NSMutableDictionary *myTogetherRequestDataDict;
    
    NSMutableDictionary *myTogether;    
    IBOutlet UINavigationBar* aNavigationBar;
    IBOutlet UINavigationItem *aNavigationItem;
    
    IBOutlet UIView* ProgressView;
    
    MyTogetherHeaderViewController *realHeader;
    
    /* Comment Array */
    NSMutableArray* comments; 
    NSMutableDictionary *commentDict;
    NSMutableArray *selectedIndexArray;
    
    /* Participants Array */
    NSMutableArray* participants;
    
    BOOL isLoading;

    
    NetworkHandler *networkHandler;
}
@property (nonatomic,retain) IBOutlet UIView* ProgressView;
@property (nonatomic,retain) MyTogetherHeaderViewController* realHeader;

- (CGFloat) getLineHeightForData : (NSString*)data;
- (BOOL) selectingForDefaultWithData: (NSString*)data;



@end
