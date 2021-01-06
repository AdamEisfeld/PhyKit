/*
Bullet Continuous Collision Detection and Physics Library
Copyright (c) 2003-2006 Erwin Coumans  http://continuousphysics.com/Bullet/

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.
Permission is granted to anyone to use this software for any purpose, 
including commercial applications, and to alter it and redistribute it freely, 
subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
*/

#pragma once

#ifndef BULLET_COLLISION_COMMON_H
#define BULLET_COLLISION_COMMON_H

///Common headerfile includes for Bullet Collision Detection

///Bullet's btCollisionWorld and btCollisionObject definitions
#import "BulletCollision/CollisionDispatch/btCollisionWorld.h"
#import "BulletCollision/CollisionDispatch/btCollisionObject.h"

///Collision Shapes
#import "BulletCollision/CollisionShapes/btBoxShape.h"
#import "BulletCollision/CollisionShapes/btSphereShape.h"
#import "BulletCollision/CollisionShapes/btCapsuleShape.h"
#import "BulletCollision/CollisionShapes/btCylinderShape.h"
#import "BulletCollision/CollisionShapes/btConeShape.h"
#import "BulletCollision/CollisionShapes/btStaticPlaneShape.h"
#import "BulletCollision/CollisionShapes/btConvexHullShape.h"
#import "BulletCollision/CollisionShapes/btTriangleMesh.h"
#import "BulletCollision/CollisionShapes/btConvexTriangleMeshShape.h"
#import "BulletCollision/CollisionShapes/btBvhTriangleMeshShape.h"
#import "BulletCollision/CollisionShapes/btScaledBvhTriangleMeshShape.h"
#import "BulletCollision/CollisionShapes/btTriangleMeshShape.h"
#import "BulletCollision/CollisionShapes/btTriangleIndexVertexArray.h"
#import "BulletCollision/CollisionShapes/btCompoundShape.h"
#import "BulletCollision/CollisionShapes/btTetrahedronShape.h"
#import "BulletCollision/CollisionShapes/btEmptyShape.h"
#import "BulletCollision/CollisionShapes/btMultiSphereShape.h"
#import "BulletCollision/CollisionShapes/btUniformScalingShape.h"

///Narrowphase Collision Detector
#import "BulletCollision/CollisionDispatch/btSphereSphereCollisionAlgorithm.h"

//#import "BulletCollision/CollisionDispatch/btSphereBoxCollisionAlgorithm.h"
#import "BulletCollision/CollisionDispatch/btDefaultCollisionConfiguration.h"

///Dispatching and generation of collision pairs (broadphase)
#import "BulletCollision/CollisionDispatch/btCollisionDispatcher.h"
#import "BulletCollision/BroadphaseCollision/btSimpleBroadphase.h"
#import "BulletCollision/BroadphaseCollision/btAxisSweep3.h"
#import "BulletCollision/BroadphaseCollision/btDbvtBroadphase.h"

///Math library & Utils
#import "LinearMath/btQuaternion.h"
#import "LinearMath/btTransform.h"
#import "LinearMath/btDefaultMotionState.h"
#import "LinearMath/btQuickprof.h"
#import "LinearMath/btIDebugDraw.h"
#import "LinearMath/btSerializer.h"

#endif  //BULLET_COLLISION_COMMON_H
