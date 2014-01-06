//
//  NewTogetherViewCell.m
//  TaxiTogether
//
//  Created by Jay on 11. 6. 25..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "NewTogetherViewCell.h"

@implementation NewTogetherViewCell
@synthesize Content,Title;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
