//
//  PersonnelInfo.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PersonnelContacts, Personnels;

@interface PersonnelInfo : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSNumber * personnelInfoId;
@property (nonatomic, retain) NSString * suffix;
@property (nonatomic, retain) Personnels *personnelInfoToPersonnel;
@property (nonatomic, retain) PersonnelContacts *personnelInfoToPersonnelContact;
@end

@interface PersonnelInfo (CoreDataGeneratedAccessors)

- (void)addPersonnelInfoToPersonnelContactObject:(PersonnelContacts *)value;
- (void)removePersonnelInfoToPersonnelContactObject:(PersonnelContacts *)value;
- (void)addPersonnelInfoToPersonnelContact:(NSSet *)values;
- (void)removePersonnelInfoToPersonnelContact:(NSSet *)values;

@end
