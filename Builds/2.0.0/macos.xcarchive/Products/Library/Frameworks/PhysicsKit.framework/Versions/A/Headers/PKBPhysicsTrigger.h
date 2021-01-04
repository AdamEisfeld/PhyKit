//
//  PKBPhysicsTrigger.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct PKVector3;
struct PKQuaternion;

@class PKBRigidBody;
@class PKBCollisionShape;

@interface PKBPhysicsTrigger : NSObject

@property (nonatomic, assign) struct PKVector3 position;
@property (nonatomic, assign) struct PKQuaternion orientation;

- (instancetype)initWithCollisionShape: (PKBCollisionShape *)collisionShape;

- (NSArray <PKBRigidBody *>*)internalGetCollidingRigidBodies;

@end

NS_ASSUME_NONNULL_END
