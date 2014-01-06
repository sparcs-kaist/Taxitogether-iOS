//
//  NewTogetherTableViewController.h
//  TaxiTogether
//
//  Created by 정 창제 on 11. 7. 9..
//  Copyright 2011년 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTogetherTableViewController : UIViewController<UIAlertViewDelegate>{
    IBOutlet UITableView *tableView;
    
    
    NSMutableDictionary *NewTogetherDataDict;
    NSMutableArray *PlacesArray;
    
    UIActivityIndicatorView *indicator;
    
    NSString *Departure;
    NSString *Destination;
    NSArray *ListTitles;
    NSDate *Today;
    NSDateFormatter* DateFormat;

    
}
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSDate* Date;
@property (nonatomic,retain) NSMutableDictionary* NewTogetherDataDict;
@end
