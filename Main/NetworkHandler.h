//
//  NetworkHandler.h
//  TaxiTogether
//
//  Created by Jay on 11. 7. 5..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface NetworkHandler : NSObject{
    
    NSMutableArray *responseDataArray;
    NSURL *url;
    NSOperationQueue *queue;
}

@property (retain) NSMutableArray *responseDataArray;
@property (retain) NSURL *url;
@property (retain) NSOperationQueue *queue;

+ (NetworkHandler *)getNetworkHandler;

- (IBAction)grabURLInBackground:(NSString *)Path callObject:(id)callObject requestDict:(NSDictionary *)requestDict method:(NSString *)Method alert:(BOOL)Alert;

-(BOOL)isNetworkReachableWithAlert:(BOOL)Alert;
-(void)hasTogetherWithDelegate:(id)delegate;
@end
