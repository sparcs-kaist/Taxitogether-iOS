//
//  SettingsViewPushTimeViewCel.h
//  TaxiTogether
//
//  Created by 정 창제 on 11. 8. 1..
//  Copyright 2011년 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewPushTimeViewCell : UITableViewCell{
    IBOutlet UILabel* title;
    IBOutlet UILabel* pushTime;
}
@property (nonatomic, retain) IBOutlet UILabel* title;
@property (nonatomic, retain) IBOutlet UILabel* pushTime;

@end
