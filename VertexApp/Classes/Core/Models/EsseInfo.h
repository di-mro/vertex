//
//  EsseInfo.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Esse, EsseContacts;

@interface EsseInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * esseInfoId;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSString * suffix;
@property (nonatomic, retain) Esse *esseInfoToEsse;
@property (nonatomic, retain) EsseContacts *esseInfoToEsseContacts;
@end

@interface EsseInfo (CoreDataGeneratedAccessors)

- (void)addEsseInfoToEsseContactsObject:(EsseContacts *)value;
- (void)removeEsseInfoToEsseContactsObject:(EsseContacts *)value;
- (void)addEsseInfoToEsseContacts:(NSSet *)values;
- (void)removeEsseInfoToEsseContacts:(NSSet *)values;

@end
