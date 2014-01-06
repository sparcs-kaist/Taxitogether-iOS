//
//  NewTogetherTimeSelectViewConrtoller.h
//  TaxiTogether
//
//  Created by Jay on 11. 7. 1..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTogetherTimeSelectViewConrtoller : UIViewController{
    IBOutlet UIDatePicker* DatePicker;
   
    NSMutableDictionary *DataDict;
    
}
@property (nonatomic,retain) UIDatePicker* DatePicker;
@property (retain) NSMutableDictionary* DataDict;
-(IBAction)onChange;
@end
