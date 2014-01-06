//
//  Together_Auth.h
//  TaxiTogether
//
//  Created by Fragarach on 7/19/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Together_Auth : UIViewController <UIScrollViewDelegate, UITextFieldDelegate> {
    
    BOOL keyboardVisible;
    IBOutlet UIImageView *frontImage;
    IBOutlet UIButton *authBotton;
    IBOutlet UIScrollView *scrollview;
    IBOutlet UITextField *userid;
    IBOutlet UIButton *background;
    CGPoint offset;
}

@property (nonatomic, retain) IBOutlet UIButton *authBotton;
@property (nonatomic, retain) IBOutlet UIImageView *frontImage;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollview;
@property (nonatomic, retain) IBOutlet UITextField *userid;

@property (nonatomic ) BOOL keyboardVisible;
@property (nonatomic) CGPoint offset;

-(IBAction) backgroundTouch: (id)sender;

@end
