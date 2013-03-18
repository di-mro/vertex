//
//  Personnels.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PersonnelInfo, Tasks;

@interface Personnels : NSManagedObject

@property (nonatomic, retain) NSNumber * personnelId;
@property (nonatomic, retain) NSNumber * personnelInfoId;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) PersonnelInfo *personnelsToPersonnelInfo;
@property (nonatomic, retain) NSSet *personnelsToTask;
@end

@interface Personnels (CoreDataGeneratedAccessors)

- (void)addPersonnelsToTaskObject:(Tasks *)value;
- (void)removePersonnelsToTaskObject:(Tasks *)value;
- (void)addPersonnelsToTask:(NSSet *)values;
- (void)removePersonnelsToTask:(NSSet *)values;

@end
