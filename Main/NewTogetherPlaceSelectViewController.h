//
//  NewTogetherPlaceSelectViewController.h
//  TaxiTogether
//
//  Created by 정 창제 on 11. 8. 3..
//  Copyright 2011년 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface NewTogetherPlaceSelectViewController : UITableViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    UIView *headerView;
    IBOutlet UILabel *lblTitle;
    IBOutlet UITextField *placeField;
    IBOutlet UISwitch *mapSelectSwitch;
    IBOutlet UITextField *addressField;
    IBOutlet UIButton *mapEditButton;
    
    NSMutableDictionary *DataDict;
    NSMutableArray *PlacesArray;
    NSString *SelectType;
    
    NSString *selectedRowStr;
    int selectedRowInt;
    
    NSOperationQueue *queue;

}
@property (nonatomic,retain) IBOutlet UILabel *lblTitle;
@property (nonatomic,retain) IBOutlet UITextField *placeField;
@property (nonatomic,retain) IBOutlet UISwitch *mapSelectSwitch;
@property (nonatomic,retain) IBOutlet UITextField *addressField;
@property (nonatomic,retain) IBOutlet UIButton *mapEditButton;
@property (nonatomic,retain) NSMutableDictionary *DataDict;
@property (nonatomic,retain) NSMutableArray *PlacesArray;
@property (nonatomic,retain) NSString *SelectType;
@property (nonatomic,retain) NSOperationQueue *queue;

-(IBAction)viewMapSelectView;
-(IBAction)removeCheckBoxWhenTextEdited;
-(void)setMapLocation;
-(IBAction)loadMapSelectViewFromButton;
-(void)getCurrentAddressWithLatitude:(float)lat Longitude:(float)lon;
@end
