//
//  CPHYCollisionShape+Internal.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#ifndef CPHYCollisionShape_Internal_h
#define CPHYCollisionShape_Internal_h

#import "CPHYDependencies+Internal.h"

@interface CPHYCollisionShape ()

@property (nonatomic, readonly) btCollisionShape* c_shape;

- (instancetype)initWithBTCollisionShape: (btCollisionShape *)collisionShape transform: (struct PHYMatrix4)transform;

@end

#endif /* CPHYCollisionShape_Internal_h */
