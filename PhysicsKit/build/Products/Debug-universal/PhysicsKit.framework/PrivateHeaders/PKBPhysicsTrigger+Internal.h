//
//  PKBPhysicsTrigger+Internal.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#ifndef PKBPhysicsTrigger_Internal_h
#define PKBPhysicsTrigger_Internal_h

#import "PKBDependencies+Internal.h"

@class PKBPhysicsWorld;

@interface PKBPhysicsTrigger ()

@property (nonatomic, readonly) btGhostObject* ghostObject;
@property (nonatomic, weak) PKBPhysicsWorld* physicsWorld;

@end

#endif /* PKBPhysicsTrigger_Internal_h */
