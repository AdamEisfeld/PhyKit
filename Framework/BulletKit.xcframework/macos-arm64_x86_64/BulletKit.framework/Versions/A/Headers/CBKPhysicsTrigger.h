//
//  CBKPhysicsTrigger.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct BKVector3;
struct BKQuaternion;

@class CBKRigidBody;
@class CBKCollisionShape;

@interface CBKPhysicsTrigger : NSObject

@property (nonatomic, assign) struct BKVector3 position;
@property (nonatomic, assign) struct BKQuaternion orientation;

- (instancetype)initWithCollisionShape: (CBKCollisionShape *)collisionShape;

- (NSArray <CBKRigidBody *>*)internalGetCollidingRigidBodies;

@end

NS_ASSUME_NONNULL_END
