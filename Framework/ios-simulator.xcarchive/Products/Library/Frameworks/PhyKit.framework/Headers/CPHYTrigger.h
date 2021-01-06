//
//  CPHYTrigger.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct PHYVector3;
struct PHYQuaternion;

@class CPHYRigidBody;
@class CPHYCollisionShape;

@interface CPHYTrigger : NSObject

@property (nonatomic, assign) struct PHYVector3 position;
@property (nonatomic, assign) struct PHYQuaternion orientation;

- (instancetype)initWithCollisionShape: (CPHYCollisionShape *)collisionShape;

- (NSArray <CPHYRigidBody *>*)internalGetCollidingRigidBodies;

@end

NS_ASSUME_NONNULL_END
