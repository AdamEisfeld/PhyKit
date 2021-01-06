//
//  CBKRigidBody.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-10.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>

struct BKVector3;
struct BKQuaternion;

typedef enum {
    CBKRigidBodyTypeStatic,
    CBKRigidBodyTypeKinematic,
    CBKRigidBodyTypeDynamic
} CBKRigidBodyType;

typedef struct BKMatrix4 (^CBKMotionStateTransformGetBlock)(void);
typedef void (^CBKMotionStateTransformSetBlock)(struct BKMatrix4);

@class CBKCollisionShape;

@interface CBKRigidBody : NSObject

@property (nonatomic) _Nullable CBKMotionStateTransformGetBlock onGetVisualTransform;
@property (nonatomic) _Nullable CBKMotionStateTransformSetBlock onSetVisualTransform;

NS_ASSUME_NONNULL_BEGIN


/// The position of the rigid body in the simulation
@property (nonatomic, assign) struct BKVector3 position;

/// The orientation, expressed as a quaternion, of the rigid body in the simulation
@property (nonatomic, assign) struct BKQuaternion orientation;

/// The orientation, expressed in euler radian angles, of the rigid body in the simulation
@property (nonatomic, assign) struct BKVector3 eulerOrientation;

/// The transform of the rigid body in the simulation
@property (nonatomic, assign) struct BKMatrix4 transform;

/// The current linear velocity of the rigid body in the simulation
@property (nonatomic, assign) struct BKVector3 linearVelocity;

/// The current angular velocity of the rigid body in the simulation
@property (nonatomic, assign) struct BKVector3 angularVelocity;

/// An optional factor to apply to the rigid body's linear velocity, allowing you to restrict
/// velocity along a given axis. For example, a linearVelocityFactor of (0,1,0) would restrict
/// the rigid body from moving along the x/z axis.
@property (nonatomic, assign) struct BKVector3 linearVelocityFactor;

/// An optional factor to apply to the rigid body's angular velocity, allowing you to restrict
/// angular velocity along a given axis. For example, an angularVelocityFactor of (0,1,0) would restrict
/// the rigid body from rotating along the x/z axis.
@property (nonatomic, assign) struct BKVector3 angularVelocityFactor;

/// The body's resistance to sliding motion
@property (nonatomic, assign) float friction;

/// The body’s resistance to rolling motion
@property (nonatomic, assign) float rollingFriction;

/// The body’s resistance to spinning motion
@property (nonatomic, assign) float spinningFriction;

/// A factor that determines how much kinetic energy the body loses or gains in collisions
@property (nonatomic, assign) float restitution;

/// A factor that reduces the body’s linear velocity
@property (nonatomic, assign) float linearDamping;

/// A factor that reduces the body’s angular velocity
@property (nonatomic, assign) float angularDamping;

/// The position of the body’s center of mass relative to its local coordinate origin
@property (nonatomic, assign) struct BKVector3 centerOfMass;

/// The threshold that determines whether this body is "sleeping" or not in it's linear velocity
@property (nonatomic, assign) float linearSleepingThreshold;

/// The threshold that determines whether this body is "sleeping" or not in it's angular velocity
@property (nonatomic, assign) float angularSleepingThreshold;

/// Whether this body causes / reacts to collisions or not
@property (nonatomic, assign) BOOL isCollisionEnabled;

/// Whether this body can be put "asleep" when it's velocities go below a certain threshold, to save on processing time
@property (nonatomic, assign) BOOL isSleepingEnabled;

/// Whether this body is affected by outside forces
@property (nonatomic, assign) BOOL isForcesEnabled;

/// If non-zero, continuous collision detection will be enabled on this body, using the specified radius
@property (nonatomic, assign) float continuousCollisionDetectionRadius;

/// The type of this rigid body, either static, kinematic, or dynamic
@property (nonatomic, readonly) CBKRigidBodyType rigidBodyType;

- (instancetype)initWithCollisionShape: (CBKCollisionShape *)collisionShape rigidBodyType: (CBKRigidBodyType)rigidBodyType mass:(float)mass;

/// Removes all forces currently applied to this rigid body
- (void)clearForces;

// Applies a force or impulse to the body at its center of mass
- (void)applyForce: (struct BKVector3)force impulse: (BOOL)impulse;

// Applies a net torque or a change in angular momentum to the body.
- (void)applyTorque: (struct BKVector3)torque impulse: (BOOL)impulse;

@end

NS_ASSUME_NONNULL_END
