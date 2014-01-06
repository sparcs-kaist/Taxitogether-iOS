//
//  DetailTogetherView.h
//  TaxiTogether
//
//  Created by 정 창제 on 11. 7. 29..
//  Copyright 2011년 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTogetherView : UITableViewController{
	NSNumber *togetherID;
    
    NSDictionary *dataDict;
    
    NSDateFormatter *dfInputFormat;
    NSDateFormatter *dfDateFormat;
    NSDateFormatter *dfTimeFormat;
    
    IBOutlet UIButton* btParticipate;
    
    IBOutlet UIView* ProgressView;

    CGFloat desc_increased;
    CGFloat depa_increased;
    CGFloat dest_increased;
        
    NSString *participantsStr;
    NSInteger numberOfParticipants;
    
    UISearchDisplayController *togetherListSearchDisplayController;
    
    BOOL isMyTogether;
}
@property (nonatomic,retain) NSNumber* togetherID;
@property (nonatomic,retain) IBOutlet UIButton* btParticipate;
@property (nonatomic,retain) IBOutlet UIView* ProgressView;
@property (nonatomic,retain) UISearchDisplayController *togetherListSearchDisplayController;
@property (nonatomic) BOOL isMyTogether;

-(IBAction)participateTogether;
- (CGFloat) getLineHeightForData : (NSString*)data;
- (BOOL) selectingForDefaultWithData: (NSString*)data;

@end
