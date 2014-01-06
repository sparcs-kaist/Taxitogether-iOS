//
//  NewTogetherViewCell.h
//  TaxiTogether
//
//  Created by Jay on 11. 6. 25..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTogetherViewCell : UITableViewCell{
    IBOutlet UILabel* Content;
    IBOutlet UILabel* Title;
}
@property (nonatomic,retain) UILabel* Content;
@property (nonatomic,retain) UILabel* Title;
@end
