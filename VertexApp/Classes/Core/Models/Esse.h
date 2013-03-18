//
//  Esse.h
//  VertexApp
//
//  Created by Mary Rose Oh on 3/11/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssetOwnership, EsseInfo, UserAccountOwnership;

@interface Esse : NSManagedObject

@property (nonatomic, retain) NSNumber * esseId;
@property (nonatomic, retain) NSNumber * esseInfoId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *esseToAssetOwnership;
@property (nonatomic, retain) EsseInfo *esseToEsseInfo;
@property (nonatomic, retain) NSSet *esseToUserAccountOwnership;
@end

@interface Esse (CoreDataGeneratedAccessors)

- (void)addEsseToAssetOwnershipObject:(AssetOwnership *)value;
- (void)removeEsseToAssetOwnershipObject:(AssetOwnership *)value;
- (void)addEsseToAssetOwnership:(NSSet *)values;
- (void)removeEsseToAssetOwnership:(NSSet *)values;

- (void)addEsseToUserAccountOwnershipObject:(UserAccountOwnership *)value;
- (void)removeEsseToUserAccountOwnershipObject:(UserAccountOwnership *)value;
- (void)addEsseToUserAccountOwnership:(NSSet *)values;
- (void)removeEsseToUserAccountOwnership:(NSSet *)values;

@end
