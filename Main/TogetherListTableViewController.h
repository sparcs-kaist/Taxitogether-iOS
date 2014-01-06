//
//  TogetherListTableViewController.h
//  TaxiTogether
//
//  Created by Jay on 11. 7. 1..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkHandler.h"
#import "Together_Auth_ViewController.h"
#import "PullRefreshTableViewController.h"

@interface TogetherListTableViewController : PullRefreshTableViewController<UISearchBarDelegate>{
    NSDateFormatter *dfOnlyDate;
    NSDateFormatter *dfInputFormat;
    NSDateFormatter *dfTableCellDateFormat;
    
    NSMutableArray *TogetherDataArray;
    NSMutableArray *Day; 
    NSMutableArray *sectionArray;
    NSMutableArray *tableArray;
    
    NSMutableArray *filteredArray;
    NSMutableArray *filteredDay;
    NSMutableArray *filteredSectionArray;
    NSMutableArray *filteredTableArray;
    
    UIActivityIndicatorView *indicator;

    
    BOOL refresh;
    int cellcount;
    int searchcellcount;
    NetworkHandler *networkHandler;
    Together_Auth_ViewController *auth_page;

}
@property (copy) NSMutableArray* TogetherDataArray;
-(void)regroupTogetherDataWithClearing:(BOOL)clear sourceArray:(NSMutableArray *)sourceArr dayArray:(NSMutableArray *)dayArray sectionArray:(NSMutableArray *)sectionArr tableArray:(NSMutableArray *)tableArr;
-(void)RefreshListTable;
-(BOOL)checkDBInfo;
@end
