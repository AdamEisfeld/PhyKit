//
//  PKBCollisionShape+Internal.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#ifndef PKBCollisionShape_Internal_h
#define PKBCollisionShape_Internal_h

#import "PKBDependencies+Internal.h"

@interface PKBCollisionShape ()

@property (nonatomic, readonly) btCollisionShape* c_shape;

- (instancetype)initWithBTCollisionShape: (btCollisionShape *)collisionShape transform: (struct PKMatrix4)transform;

@end

#endif /* PKBCollisionShape_Internal_h */
