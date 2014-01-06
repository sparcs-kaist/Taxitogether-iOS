//
//  NewTogetherPlaceMapProtocol.h
//  TaxiTogether
//
//  Created by 정 창제 on 11. 8. 14..
//  Copyright (c) 2011년 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ASIFormDataRequest.h"

@interface TogetherPlaceMapAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    
    NSURL *loc_url;
    NSString *fetchURL;
    ASIHTTPRequest *loc_request;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c;
-(void)updateSubtitleWithLatitude:(float)lat Longitude:(float)lon;

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic, retain) ASIHTTPRequest *loc_request;

@end
