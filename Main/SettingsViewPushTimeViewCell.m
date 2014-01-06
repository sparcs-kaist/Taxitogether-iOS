//
//  SettingsViewPushTimeViewCel.m
//  TaxiTogether
//
//  Created by 정 창제 on 11. 8. 1..
//  Copyright 2011년 KAIST. All rights reserved.
//

#import "SettingsViewPushTimeViewCell.h"

@implementation SettingsViewPushTimeViewCell
@synthesize pushTime,title;

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
