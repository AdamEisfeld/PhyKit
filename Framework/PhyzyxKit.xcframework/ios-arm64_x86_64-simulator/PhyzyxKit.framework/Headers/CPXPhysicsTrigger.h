//
//  CPXPhysicsTrigger.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct PXVector3;
struct PXQuaternion;

@class CPXRigidBody;
@class CPXCollisionShape;

@interface CPXPhysicsTrigger : NSObject

@property (nonatomic, assign) struct PXVector3 position;
@property (nonatomic, assign) struct PXQuaternion orientation;

- (instancetype)initWithCollisionShape: (CPXCollisionShape *)collisionShape;

- (NSArray <CPXRigidBody *>*)internalGetCollidingRigidBodies;

@end

NS_ASSUME_NONNULL_END
