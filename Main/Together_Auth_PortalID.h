//
//  Together_Auth_PortalID.h
//  TaxiTogether
//
//  Created by Fragarach on 7/31/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Together_Auth_PortalID : UITableViewCell {
    
    IBOutlet UITextField* portalID;
    IBOutlet UIToolbar *toolbar;
    IBOutlet UISegmentedControl *prevnext;
    IBOutlet UIBarButtonItem *done;
}

@property (retain, nonatomic) IBOutlet UITextField* portalID;
@property (retain, nonatomic) IBOutlet UIToolbar* toolbar;
@property (retain, nonatomic) IBOutlet UISegmentedControl *prevnext;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *done;

@end
