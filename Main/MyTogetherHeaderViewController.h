//
//  MyTogetherHeaderViewController.h
//  TaxiTogether
//
//  Created by Fragarach on 7/28/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkHandler.h"

@interface MyTogetherHeaderViewController : UITableViewController <UIAlertViewDelegate>{

    IBOutlet UIButton *quitTogetherButton;    
    BOOL isPassed;
    
    NSMutableArray* participants;
    NSMutableDictionary* myTogether;
    NSString *participantsStr;
    int numberOfParticipants;
    
    NSDateFormatter* dfDateFormat;
    NSDateFormatter* dfTimeFormat;
    NSDateFormatter* dfInputFormat;
    
    UIView* ProgressView;
    UIView* myTogetherView;
    UIViewController* myTogetherViewController;
    
    NetworkHandler *networkHandler;
    
    UINavigationController* navigationController;
    UITabBarController* tabBarController;
    UITableView* commentTable;
    NSMutableArray *selectedIndexArray;
    
    CGFloat increased;
    CGFloat depa_increased;
    CGFloat dest_increased;
    CGFloat desc_increased;
    
}
@property (nonatomic,retain) IBOutlet UIButton *quitTogetherButton;
@property (nonatomic,retain) NSMutableArray* participants;
@property (nonatomic,retain) NSMutableDictionary* myTogether;
@property (nonatomic,retain) UINavigationController* navigationController;
@property (nonatomic,retain) UITabBarController* tabBarController;
@property (nonatomic,retain) UITableView* commentTable;
@property (nonatomic,retain) UIView* ProgressView;
@property (nonatomic,retain) UIView* myTogetherView;
@property (nonatomic,retain) UIViewController* myTogetherViewController;
@property (nonatomic) BOOL isPassed;

@property (nonatomic) CGFloat increased;
@property (nonatomic) CGFloat depa_increased;
@property (nonatomic) CGFloat dest_increased;
@property (nonatomic) CGFloat desc_increased;

@property (nonatomic, retain) NSString *participantsStr;
@property (nonatomic) int numberOfParticipants;

@end
