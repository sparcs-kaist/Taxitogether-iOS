//
//  SettingsViewCellController.h
//  TaxiTogether
//
//  Created by Fragarach on 7/30/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewCellController : UITableViewCell {
    
    IBOutlet UILabel *title;
    IBOutlet UILabel *desc;
}
@property (retain,nonatomic) IBOutlet UILabel* title;
@property (retain,nonatomic) IBOutlet UILabel* desc;

@end
