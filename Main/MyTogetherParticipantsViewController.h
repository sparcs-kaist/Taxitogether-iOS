//
//  MyTogetherParticipantsViewController.h
//  TaxiTogether
//
//  Created by Fragarach on 7/26/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkHandler.h"
#import "DBHandler.h"

@interface MyTogetherParticipantsViewController : UITableViewController<UIActionSheetDelegate> {
    
    NSMutableArray *listOfParticipants;
    //NSMutableArray *rawListOfParticipants;
    int selectedPath;
    
    NetworkHandler* networkHandler;
    DBHandler* dbHandler;
    
    NSString* togetherId;
    
    NSURL *net;
    
    UIDevice *device;
}
@property (nonatomic, retain) NSMutableArray* listOfParticipants;
@property (nonatomic, retain) NSString* togetherId;

@end
