//
//  SQLiteManager.h
//  VertexApp
//
//  Created by Mary Rose Oh on 5/28/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface SQLiteManager : NSObject
{
  sqlite3 *db;
}

-(NSString *) getFilePath;

-(sqlite3 *) openDB;

@end
