//
//  CBKCollisionShape.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBKGeometry;
@class CBKCollisionShape;
@class CBKGeometry;

struct BKMatrix4;

@interface CBKCollisionShape : NSObject

@property (nonatomic, assign) struct BKMatrix4 transform;
@property (nonatomic, assign) float margin;

- (instancetype)init;
- (instancetype)initWithSerializedData: (NSData *)serializedData;
- (instancetype)initSphereWithRadius: (float)radius transform: (struct BKMatrix4)transform;
- (instancetype)initBoxWithWidth: (float)width height: (float)height length: (float)length transform: (struct BKMatrix4)transform;
- (instancetype)initCapsuleWithRadius: (float)radius height: (float)height transform: (struct BKMatrix4)transform;
- (instancetype)initCylinderWithRadius:(float)radius height:(float)height transform:(struct BKMatrix4)transform;
- (instancetype)initStaticPlaneWithDirection:(struct BKVector3)direction transform:(struct BKMatrix4)transform;
- (instancetype)initWithCollisionShape: (CBKCollisionShape *)collisionShape transform: (struct BKMatrix4)transform;
- (instancetype)initWithCollisionShapes: (NSArray <CBKCollisionShape *>*)collisionShapes transform: (struct BKMatrix4)transform;
- (instancetype)initConvexHullWithGeometry: (CBKGeometry *)geometry transform: (struct BKMatrix4)transform;
- (instancetype)initTriangleMeshWithGeometry: (CBKGeometry *)geometry transform: (struct BKMatrix4)transform;

- (NSData *)serialize;

@end

NS_ASSUME_NONNULL_END
