//
//  PKBRigidBody+Internal.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-10.
//  Copyright © 2020 adam. All rights reserved.
//

#ifndef PKBRigidBody_Internal_h
#define PKBRigidBody_Internal_h

#import "PKBDependencies+Internal.h"

@class PKBPhysicsWorld;

@interface PKBRigidBody ()

@property (nonatomic, readonly) btRigidBody* c_body;
@property (nonatomic, weak) PKBPhysicsWorld* physicsWorld;

@end

#endif /* PKBRigidBody_Internal_h */
