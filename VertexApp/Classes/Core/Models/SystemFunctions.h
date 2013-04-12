//
//  SystemFunctions.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProfileFunctions, SystemProfileSequence;

@interface SystemFunctions : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * systemFunctionId;
@property (nonatomic, retain) ProfileFunctions *systemFunctionToProfileFunction;
@property (nonatomic, retain) SystemProfileSequence *systemFunctionToSystemFunctionHierarchies;
@end

@interface SystemFunctions (CoreDataGeneratedAccessors)

- (void)addSystemFunctionToProfileFunctionObject:(ProfileFunctions *)value;
- (void)removeSystemFunctionToProfileFunctionObject:(ProfileFunctions *)value;
- (void)addSystemFunctionToProfileFunction:(NSSet *)values;
- (void)removeSystemFunctionToProfileFunction:(NSSet *)values;

- (void)addSystemFunctionToSystemFunctionHierarchiesObject:(SystemProfileSequence *)value;
- (void)removeSystemFunctionToSystemFunctionHierarchiesObject:(SystemProfileSequence *)value;
- (void)addSystemFunctionToSystemFunctionHierarchies:(NSSet *)values;
- (void)removeSystemFunctionToSystemFunctionHierarchies:(NSSet *)values;

@end
