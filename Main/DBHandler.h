//
//  DBHandler.h
//  TaxiTogether
//
//  Created by Fragarach on 7/20/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DBHandler : NSObject {
    
    NSString *databaseName;
    NSString *databasePath;   
    NSString *documentsDir;
    NSArray *documentPaths;
    
    NSMutableDictionary *userinfo;
}

@property (nonatomic, retain) NSMutableDictionary *userinfo;

+(DBHandler *)getDBHandler;
-(void) checkAndCreateDatabase;
-(void) readUserInfo;
-(void) updateUserInfo : (NSString *)userid withKey:(NSString *)key;

@end
