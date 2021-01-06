//
//  PHYStructs+Internal.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

#ifndef BLStructs_Internal_h
#define BLStructs_Internal_h

#import "CPHYDependencies+Internal.h"

#ifdef __cplusplus
extern "C" {
#endif

extern struct PHYMatrix4 PHYMatrix4MakeFrom(btTransform c_transform);

#ifdef __cplusplus
}
#endif

extern struct btTransform btTransformMakeFrom(PHYMatrix4 transform);
extern struct btTransform btTransformMakeFrom(PHYMatrix4 transform);

#endif /* BLStructs_Internal_h */
