//
//  DetailTogetherViewCell.h
//  TaxiTogether
//
//  Created by 정 창제 on 11. 7. 29..
//  Copyright 2011년 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTogetherViewCell : UITableViewCell{
    IBOutlet UILabel *title;
    IBOutlet UILabel *content;
}

@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UILabel *content;

@end
