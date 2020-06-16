//
//  BLStructs+Internal.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

#ifndef BLStructs_Internal_h
#define BLStructs_Internal_h

#import "PKBDependencies+Internal.h"

#ifdef __cplusplus
extern "C" {
#endif

extern struct PKMatrix4 PKMatrix4MakeFrom(btTransform c_transform);

#ifdef __cplusplus
}
#endif

extern struct btTransform btTransformMakeFrom(PKMatrix4 transform);

#endif /* BLStructs_Internal_h */
