//
//  CPHYRigidBody+Internal.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-10.
//  Copyright © 2020 adam. All rights reserved.
//

#ifndef CPHYRigidBody_Internal_h
#define CPHYRigidBody_Internal_h

#import "CPHYDependencies+Internal.h"

@class CPHYWorld;

@interface CPHYRigidBody ()

@property (nonatomic, readonly) btRigidBody* c_body;
@property (nonatomic, weak) CPHYWorld* physicsWorld;

@end

#endif /* CPHYRigidBody_Internal_h */
