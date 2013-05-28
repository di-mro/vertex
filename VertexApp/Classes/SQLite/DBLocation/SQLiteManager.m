//
//  SQLiteManager.m
//  VertexApp
//
//  Created by Mary Rose Oh on 5/28/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "SQLiteManager.h"

@implementation SQLiteManager

#pragma mark - Set file path to db
-(NSString *) getFilePath
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
  return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"di_vertex.sql"];
}

#pragma mark - Open the db
-(sqlite3 *) openDB
{
  if(sqlite3_open([[self getFilePath] UTF8String], &db) != SQLITE_OK)
  {
    sqlite3_close(db);
    NSLog(@"Database failed to open");
  }
  else
  {
    NSLog(@"Database opened");
  }
  
  return db;
}

@end
