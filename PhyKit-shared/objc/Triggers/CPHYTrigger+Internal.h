//
//  CPHYTrigger+Internal.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#ifndef CPHYTrigger_Internal_h
#define CPHYTrigger_Internal_h

#import "CPHYDependencies+Internal.h"

@class CPHYWorld;

@interface CPHYTrigger ()

@property (nonatomic, readonly) btGhostObject* ghostObject;
@property (nonatomic, weak) CPHYWorld* physicsWorld;

@end

#endif /* CPHYTrigger_Internal_h */
