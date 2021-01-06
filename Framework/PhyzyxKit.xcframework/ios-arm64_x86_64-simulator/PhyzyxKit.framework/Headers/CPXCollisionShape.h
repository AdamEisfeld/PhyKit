//
//  CPXCollisionShape.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CPXGeometry;
@class CPXCollisionShape;
@class CPXGeometry;

struct PXMatrix4;

@interface CPXCollisionShape : NSObject

@property (nonatomic, assign) struct PXMatrix4 transform;
@property (nonatomic, assign) float margin;

- (instancetype)init;
- (instancetype)initWithSerializedData: (NSData *)serializedData;
- (instancetype)initSphereWithRadius: (float)radius transform: (struct PXMatrix4)transform;
- (instancetype)initBoxWithWidth: (float)width height: (float)height length: (float)length transform: (struct PXMatrix4)transform;
- (instancetype)initCapsuleWithRadius: (float)radius height: (float)height transform: (struct PXMatrix4)transform;
- (instancetype)initCylinderWithRadius:(float)radius height:(float)height transform:(struct PXMatrix4)transform;
- (instancetype)initStaticPlaneWithDirection:(struct PXVector3)direction transform:(struct PXMatrix4)transform;
- (instancetype)initWithCollisionShape: (CPXCollisionShape *)collisionShape transform: (struct PXMatrix4)transform;
- (instancetype)initWithCollisionShapes: (NSArray <CPXCollisionShape *>*)collisionShapes transform: (struct PXMatrix4)transform;
- (instancetype)initConvexHullWithGeometry: (CPXGeometry *)geometry transform: (struct PXMatrix4)transform;
- (instancetype)initTriangleMeshWithGeometry: (CPXGeometry *)geometry transform: (struct PXMatrix4)transform;

- (NSData *)serialize;

@end

NS_ASSUME_NONNULL_END
