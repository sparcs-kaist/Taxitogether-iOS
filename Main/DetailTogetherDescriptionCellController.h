//
//  DetailTogetherDescriptionCellController.h
//  TaxiTogether
//
//  Created by Fragarach on 7/30/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailTogetherDescriptionCellController : UITableViewCell {
    
    IBOutlet UILabel* desctitle;
    IBOutlet UILabel* descdesc;
}
@property(retain,nonatomic) IBOutlet UILabel* desctitle;
@property(retain,nonatomic) IBOutlet UILabel* descdesc;
@end
