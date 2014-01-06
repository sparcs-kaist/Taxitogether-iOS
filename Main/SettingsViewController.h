//
//  SettingsViewController.h
//  TaxiTogether
//
//  Created by Fragarach on 7/30/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Asyncimageview.h"

@interface SettingsViewController : UITableViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate> {
    
    IBOutlet UIView* header;
    IBOutlet UIImageView* profileImage;
    IBOutlet UIButton *profileImageButton;
    IBOutlet UINavigationItem *aNavigationItem;
    
    AsyncImageView *asyncProfileView;
    NSMutableDictionary *profile;
    NSURL *net;
    
    NSDecimalNumber *pushTime;
    
    IBOutlet UIView* ProgressView;
    IBOutlet UIView* largeProgressView;
}

@property (nonatomic,retain) IBOutlet UIView* header;
@property (nonatomic,retain) IBOutlet UIImageView* profileImage;
@property (nonatomic,retain) IBOutlet UIButton* profileImageButton;
@property (nonatomic,retain) IBOutlet UIView* ProgressView;
@property (nonatomic,retain) IBOutlet UIView* largeProgressView;


@end
