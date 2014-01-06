//
//  NewTogetherPlaceMapProtocol.m
//  TaxiTogether
//
//  Created by 정 창제 on 11. 8. 14..
//  Copyright (c) 2011년 KAIST. All rights reserved.
//

#import "TogetherPlaceMapAnnotation.h"
#import "SBJsonParser.h"
#import "ASIFormDataRequest.h"

@implementation TogetherPlaceMapAnnotation
@synthesize coordinate,subtitle,title, loc_request;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	return self;
}


-(void) updateSubtitleWithLatitude:(float)lat Longitude:(float)lon 
{

    [self willChangeValueForKey:@"subtitle"];
    self.subtitle = nil;
    [self didChangeValueForKey:@"subtitle"];
    fetchURL = [NSString stringWithFormat:@"http://maps.google.co.kr/maps/geo?q=%@,%@&language=ko&output=json&sensor=true", 
                          [NSString stringWithFormat:@"%f",lat], 
                 [NSString stringWithFormat:@"%f",lon]];
    loc_url = [[NSURL alloc] initWithString:fetchURL];
    

    loc_request = [ASIHTTPRequest requestWithURL:loc_url];
    [loc_request retain];
    [loc_request setShouldAttemptPersistentConnection:NO];
    [loc_request setRequestMethod:@"GET"];
    [loc_request setDelegate:self];
    [loc_request setTimeOutSeconds:4.0];
    [loc_request startAsynchronous];
}

-(void) dealloc
{   
    if ( ![loc_request isFinished]){
        [loc_request clearDelegatesAndCancel];
        
    }
    [loc_request release];
    [super dealloc];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [self willChangeValueForKey:@"subtitle"];
    self.subtitle = @"주소 가져오기에 실패하였습니다.";
    [self didChangeValueForKey:@"subtitle"];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSString *htmlData =[request responseString];
    NSString *currentAddress; 
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *json = [parser objectWithString:htmlData];
    NSArray *placemark = [json objectForKey:@"Placemark"];
    currentAddress=[[placemark objectAtIndex:0]objectForKey:@"address"];
    
    [parser release];
    
    NSString *address;
    NSRange rangeOfSubstring = [currentAddress rangeOfString:@"대한민국 "];
    
    if(rangeOfSubstring.location == NSNotFound)
    {
        address=currentAddress;
    }
    else
    {
        address=[currentAddress substringFromIndex:rangeOfSubstring.location+5];
    }
    
    [self willChangeValueForKey:@"subtitle"];
    self.subtitle = address;
    [self didChangeValueForKey:@"subtitle"];
}

@end
