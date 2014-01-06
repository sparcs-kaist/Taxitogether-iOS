//
//  DBHandler.m
//  TaxiTogether
//
//  Created by Fragarach on 7/20/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHandler.h"
#import <sqlite3.h>

@implementation DBHandler
@synthesize userinfo;

+(DBHandler *)getDBHandler{
    static DBHandler *dbHandler = nil;
    //NSLog(@"dbHandler");
    
    if(dbHandler == nil)
    {
        //NSLog(@"dbHandler2");
        @synchronized(self)
        {
            if(dbHandler == nil)
            {
                dbHandler = [[self alloc] init];
            }
        }
    }
    return dbHandler;
}

- (id) init 
{
	// Init the animals Array
    self = [super init];
    
    if ( self ){
        userinfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil, @"userid", nil, @"key", nil];
        
        // Get the path to the documents directory and append the databaseName
        documentPaths = [[NSArray alloc] initWithArray:(NSArray*) NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)];
        documentsDir = [[NSString alloc] initWithString:(NSString *)[documentPaths objectAtIndex:0]];
        databaseName = [[NSString alloc] initWithString:(NSString *)@"taxitogether-raw.db"];
        //databaseName = [[NSString alloc] initWithString:(NSString *)@"taxitogether.db"];
        databasePath = [[NSString alloc] initWithString:(NSString *)[documentsDir stringByAppendingPathComponent:databaseName]];
        
        // Execute the "checkAndCreateDatabase" function
        [self checkAndCreateDatabase];

        // Query the database for all user information
        [self readUserInfo];
    }
    return self;
}

-(void) checkAndCreateDatabase
{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
    //NSLog(@"checkAndCreateDatabase");
    
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
    
	// If the database already exists then return without doing anything
	if(success) return;
    
	// If not then proceed to copy the database from the application to the users filesystem
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    
}

-(void) readUserInfo
{
	// Setup the database object
	sqlite3 *database;
    //NSLog(@"readUserInfo %@", databasePath);

	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        //NSLog(@"readUserInfo2");
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "SELECT * FROM taxitogether WHERE id = 1";
		sqlite3_stmt *compiledStatement;
        
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            //NSLog(@"readUserInfo3");

			// we will get only one tuple            
			if(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                //NSLog(@"readUserInfo4");                
				// Read the data from the result row
				NSString *userid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *key = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                [userinfo setObject:userid forKey:@"userid"];
                [userinfo setObject:key forKey:@"key"];
                //NSLog(@"USERID : %@ , KEY : %@", userid, key);
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
}

- (void) updateUserInfo : (NSString *)userid withKey:(NSString *)key
{
    //NSLog(@"updateUserInfo0 %@", databasePath);
    // Setup the database object
	sqlite3 *database;
    int success = -1;
    
    //NSLog(@"updateUserInfo %@", databasePath);
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        //NSLog(@"updateUserInfo2");
		// Setup the SQL Statement and compile it for faster access
        NSString *statement = [[NSString alloc] 
                               initWithFormat:@"UPDATE taxitogether SET userid=\"%@\" , key=\"%@\" WHERE id = 1",
                               userid, key];
		const char *sqlStatement = [statement UTF8String];
		sqlite3_stmt *compiledStatement;
        
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            //NSLog(@"updateUserInfo3");
            
			// we will get only one tuple            
			success = sqlite3_step(compiledStatement);
            if (success != SQLITE_DONE )
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Title"
                                                            message:@"인증이 실패하였습니다. 다시 시도해주세요"
                                                            delegate:nil
                                                          cancelButtonTitle:@"확인"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
                [alertView release];
            }
        }
        // Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        [statement release];
	}
    
    sqlite3_close(database);
    [self readUserInfo];
}

@end
