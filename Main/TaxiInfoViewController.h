//
//  TaxiInfo.h
//  TaxiTogether
//
//  Created by Jay on 11. 7. 1..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaxiInfoViewController: UIViewController {
    
    IBOutlet UIImageView* background;
    int isiPhone;
    NSArray* taxiPhone;
    NSArray* taxiComp;
    int selectedButtonIndex;
}
@property (nonatomic, retain) IBOutlet UIImageView* background;

@end
