//
//  UserAccountInfoManager.m
//  VertexApp
//
//  Created by Mary Rose Oh on 5/28/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "UserAccountInfoManager.h"
#import "SQLiteManager.h"

@implementation UserAccountInfoManager


#pragma mark - SQLite Operations

/*
#pragma mark - Set file path to db
-(NSString *) getFilePath
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
  NSLog(@"paths: %@", paths);
  return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"di_vertex.sql"];
}
*/


#pragma mark - Open the db
-(void) openDB
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
  NSLog(@"paths: %@", paths);

  if(sqlite3_open([[[paths objectAtIndex:0] stringByAppendingPathComponent:@"di_vertex.sql"] UTF8String], &db) != SQLITE_OK)
  {
    sqlite3_close(db);
    NSLog(@"Database failed to open");
  }
  else
  {
    NSLog(@"Database opened");
  }
}


#pragma mark - Create user_accounts table
-(void) createTable: (NSString *) tableName //user_accounts
         withField1: (NSString *) field1 //userId
         withField2: (NSString *) field2 //username
         withField3: (NSString *) field3 //password
         withField4: (NSString *) field4 //profileId
         withField5: (NSString *) field5 //userInfoId
         withField6: (NSString *) field6 //token
{
  char *err;
  NSString *sql = [NSString stringWithFormat:
                   @"CREATE TABLE IF NOT EXISTS '%@' ('%@' " "NUM PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' NUM, '%@' NUM, '%@' TEXT);"
                   , tableName
                   , field1
                   , field2
                   , field3
                   , field4
                   , field5
                   , field6];
  
  if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
  {
    sqlite3_close(db);
    NSLog(@"Could not create table");
  }
  else
  {
    NSLog(@"Table Created");
  }
}


#pragma mark - Collect User Accounts data from response parameter and save to db
-(void) saveUserInfo: (NSNumber *) userId
                    : (NSString *) username
                    : (NSString *) password
                    : (NSNumber *) userProfileId
                    : (NSNumber *) userInfoId
                    : (NSString *) token
{
  //Truncate user_accounts first to remove unecessary info, only save info for the logged user
  [self truncateUserAccounts];
  
  NSString *sql = [NSString stringWithFormat:@"INSERT INTO user_accounts ('userId', 'username', 'password', 'profileId', 'userInfoId', 'token') VALUES ('%@', '%@', '%@', '%@', '%@', '%@')"
                   , userId
                   , username
                   , password
                   , userProfileId
                   , userInfoId
                   , token];
  
  char *err;
  if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
  {
    sqlite3_close(db);
    NSLog(@"Could not update the table");
  }
  else
  {
    NSLog(@"Table Updated");
  }
}


#pragma mark - Retrieve logged user account information
-(NSNumber *) retrieveInfoFromDB
{
  [self openDB];
  
  //user_accounts table only stores the information for the current logged user
  NSString *sql = [NSString stringWithFormat:@"SELECT * FROM user_accounts"];
  sqlite3_stmt *statement;
  
  NSNumber *userProfileId = [[NSNumber alloc] init];
  
  if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
  {
    //NSLog(@"statement: %@", statement);
    while(sqlite3_step(statement) == SQLITE_ROW)
    {
      //userId
      char *field1 = (char *) sqlite3_column_text(statement, 0);
      NSString *userId = [[NSString alloc] initWithUTF8String:field1];
      NSLog(@"userId: %@", userId);
      
      //username
      char *field2 = (char *) sqlite3_column_text(statement, 1);
      NSString *username = [[NSString alloc] initWithUTF8String:field2];
      NSLog(@"username: %@", username);
      
      //password
      char *field3 = (char *) sqlite3_column_text(statement, 2);
      NSString *password = [[NSString alloc] initWithUTF8String:field3];
      NSLog(@"password: %@", password);
      
      //profileId
      char *field4 = (char *) sqlite3_column_text(statement, 3);
      NSString *profileIdString = [[NSString alloc] initWithUTF8String:field4];
      userProfileId = profileIdString;
      NSLog(@"userProfileId: %@", profileIdString);
      
      //userInfoId
      char *field5 = (char *) sqlite3_column_text(statement, 4);
      NSString *userInfoId = [[NSString alloc] initWithUTF8String:field5];
      NSLog(@"userInfoId: %@", userInfoId);
      
      //token
      char *field6 = (char *) sqlite3_column_text(statement, 5);
      NSString *token = [[NSString alloc] initWithUTF8String:field6];
      NSLog(@"token: %@", token);
    }
  }
  return userProfileId;
}


#pragma mark - Retrieve token from user_accounts
-(NSString *) retrieveToken
{
  [self openDB];
  
  //user_accounts table only stores the information for the current logged user - one entry
  NSString *sql = [NSString stringWithFormat:@"SELECT token FROM user_accounts"];
  sqlite3_stmt *statement;
  
  NSString *token = [[NSString alloc] init];
  
  if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
  {
    while(sqlite3_step(statement) == SQLITE_ROW)
    {
      //token
      char *field1 = (char *) sqlite3_column_text(statement, 0);
      token = [[NSString alloc] initWithUTF8String:field1];
      NSLog(@"token: %@", token);
    }
  }
  return token;
}


#pragma mark - Truncate user_accounts table
-(void) truncateUserAccounts
{
  char *err;
  NSString *sql = [NSString stringWithFormat:@"DELETE FROM user_accounts"];
  
  if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
  {
    sqlite3_close(db);
    NSLog(@"Could not truncate user_accounts table");
  }
  else
  {
    NSLog(@"user_accounts table truncated");
  }
}



@end
