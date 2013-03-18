//
//  SystemFunctionHierarchies.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SystemFunctions;

@interface SystemFunctionHierarchies : NSManagedObject

@property (nonatomic, retain) NSNumber * next;
@property (nonatomic, retain) NSNumber * prev;
@property (nonatomic, retain) NSNumber * systemFunctionId;
@property (nonatomic, retain) SystemFunctions *systemFunctionHierarchiesToSystemFunction;
@end

@interface SystemFunctionHierarchies (CoreDataGeneratedAccessors)

- (void)addSystemFunctionHierarchiesToSystemFunctionObject:(SystemFunctions *)value;
- (void)removeSystemFunctionHierarchiesToSystemFunctionObject:(SystemFunctions *)value;
- (void)addSystemFunctionHierarchiesToSystemFunction:(NSSet *)values;
- (void)removeSystemFunctionHierarchiesToSystemFunction:(NSSet *)values;

@end
