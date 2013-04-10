//
//  SystemProfileSequence.h
//  VertexApp
//
//  Created by Mary Rose Oh on 4/8/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SystemFunctions;

@interface SystemProfileSequence : NSManagedObject

@property (nonatomic, retain) NSNumber * next;
@property (nonatomic, retain) NSNumber * prev;
@property (nonatomic, retain) NSNumber * systemFunctionId;
@property (nonatomic, retain) NSSet *systemFunctionHierarchiesToSystemFunction;
@end

@interface SystemProfileSequence (CoreDataGeneratedAccessors)

- (void)addSystemFunctionHierarchiesToSystemFunctionObject:(SystemFunctions *)value;
- (void)removeSystemFunctionHierarchiesToSystemFunctionObject:(SystemFunctions *)value;
- (void)addSystemFunctionHierarchiesToSystemFunction:(NSSet *)values;
- (void)removeSystemFunctionHierarchiesToSystemFunction:(NSSet *)values;

@end
