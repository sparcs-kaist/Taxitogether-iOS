//
//  SettingsViewPushTimeViewController.h
//  TaxiTogether
//
//  Created by 정 창제 on 11. 8. 1..
//  Copyright 2011년 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
@interface SettingsViewPushTimeViewController : UITableViewController{
    NSDecimalNumber *pushTime;
    SettingsViewController *SettingsViewObject;
}
@property (nonatomic,retain) NSDecimalNumber *pushTime;
@property (nonatomic,retain) SettingsViewController* SettingsViewObject; 
@end
