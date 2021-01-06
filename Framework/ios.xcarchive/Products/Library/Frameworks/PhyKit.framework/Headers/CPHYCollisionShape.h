//
//  CPHYCollisionShape.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CPHYGeometry;
@class CPHYCollisionShape;
@class CPHYGeometry;

struct PHYMatrix4;

@interface CPHYCollisionShape : NSObject

@property (nonatomic, assign) struct PHYMatrix4 transform;
@property (nonatomic, assign) float margin;

- (instancetype)init;
- (instancetype)initWithSerializedData: (NSData *)serializedData;
- (instancetype)initSphereWithRadius: (float)radius transform: (struct PHYMatrix4)transform;
- (instancetype)initBoxWithWidth: (float)width height: (float)height length: (float)length transform: (struct PHYMatrix4)transform;
- (instancetype)initCapsuleWithRadius: (float)radius height: (float)height transform: (struct PHYMatrix4)transform;
- (instancetype)initCylinderWithRadius:(float)radius height:(float)height transform:(struct PHYMatrix4)transform;
- (instancetype)initStaticPlaneWithDirection:(struct PHYVector3)direction transform:(struct PHYMatrix4)transform;
- (instancetype)initWithCollisionShape: (CPHYCollisionShape *)collisionShape transform: (struct PHYMatrix4)transform;
- (instancetype)initWithCollisionShapes: (NSArray <CPHYCollisionShape *>*)collisionShapes transform: (struct PHYMatrix4)transform;
- (instancetype)initConvexHullWithGeometry: (CPHYGeometry *)geometry transform: (struct PHYMatrix4)transform;
- (instancetype)initTriangleMeshWithGeometry: (CPHYGeometry *)geometry transform: (struct PHYMatrix4)transform;

- (NSData *)serialize;

@end

NS_ASSUME_NONNULL_END
