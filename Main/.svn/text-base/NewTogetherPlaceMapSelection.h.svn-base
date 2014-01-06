//
//  NewTogetherPlaceMapSelection.h
//  TaxiTogether
//
//  Created by 정 창제 on 11. 8. 4..
//  Copyright 2011년 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NewTogetherPlaceMapSelection : UIViewController<MKMapViewDelegate,UIActionSheetDelegate>{
    IBOutlet UINavigationBar *navBar;
    IBOutlet UINavigationItem *navItem;
    IBOutlet MKMapView* selectMapView;
    
    NSMutableDictionary *DataDict;
    NSString *SelectType;
    
    NSDictionary *addressDict;
    
    CLLocationCoordinate2D locCoordDepa;
    CLLocationCoordinate2D locCoordDest;
    UITapGestureRecognizer *tapGesture;
}
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;
@property (nonatomic, retain) IBOutlet MKMapView* selectMapView;
@property (nonatomic, retain) NSMutableDictionary *DataDict;
@property (nonatomic, retain) NSString *SelectType;
@end
