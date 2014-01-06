//
//  MyTogetherHeaderParticipantsViewCell.h
//  TaxiTogether
//
//  Created by Fragarach on 8/9/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyTogetherHeaderParticipantsViewCell : UITableViewCell {
    
    IBOutlet UILabel* title;
    IBOutlet UILabel* content;
}
@property (nonatomic,retain) IBOutlet UILabel* title;
@property (nonatomic,retain) IBOutlet UILabel* content;
@end
