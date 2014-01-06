//
//  NewTogetherPlaceTextInputViewController.h
//  TaxiTogether
//
//  Created by Jay on 11. 7. 3..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTogetherPlaceTextInputViewController : UIViewController{
    IBOutlet UITextField* TextInput;
    NSMutableDictionary *DataDict;
    NSString *SelectType;
}
@property (retain) NSMutableDictionary* DataDict;
@property (nonatomic,retain) IBOutlet UITextField* TextInput;
@property (retain) NSString *SelectType;

@end
