//
//  MyTogetherHeaderDescriptionCellController.h
//  TaxiTogether
//
//  Created by Fragarach on 7/30/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyTogetherHeaderDescriptionCellController : UITableViewCell {
    
    IBOutlet UILabel *descTitle;
    IBOutlet UILabel *descdesc;
}

@property (retain,nonatomic) IBOutlet UILabel *descTitle;
@property (retain,nonatomic) IBOutlet UILabel *descdesc;

@end
