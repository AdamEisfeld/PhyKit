//
//  PKBPhysicsTrigger.m
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import "PKBPhysicsTrigger.h"
#import "PKBPhysicsTrigger+Internal.h"
#import "PKBPhysicsWorld.h"
#import "PKBStructs.h"
#import "PKBCollisionShape.h"
#import "PKBCollisionShape+Internal.h"

@interface PKBPhysicsTrigger() {
    
    btCollisionShape* _c_shape;
    
}

@end

@implementation PKBPhysicsTrigger

// MARK: Initialization

- (instancetype)initWithCollisionShape: (PKBCollisionShape *)collisionShape {
    self = [super init];
    if (self) {
        _c_shape = collisionShape.c_shape;
        _ghostObject = [self createGhostObject:_c_shape];
    }
    return self;
}

- (btGhostObject *)createGhostObject: (btCollisionShape *)shape {
    btGhostObject *result = new btGhostObject();
    result->setCollisionShape(shape);
    result->setCollisionFlags(result->getCollisionFlags() | btCollisionObject::CF_NO_CONTACT_RESPONSE);
    result->setUserPointer((__bridge void*)self);
    return result;
}

// MARK: Deallocation

- (void)dealloc {
    [_physicsWorld internalRemovePhysicsTrigger:self];
    delete _ghostObject;
    delete _c_shape;
}

// MARK: Transform

- (PKVector3)position {
    if (_ghostObject) {
        btTransform c_transform = _ghostObject->getWorldTransform();
        btVector3 c_position = c_transform.getOrigin();
        return PKVector3Make(c_position.x(), c_position.y(), c_position.z());
    } else {
        return PKVector3Make(0,0,0);
    }
}

- (void)setPosition:(PKVector3)position {
    if (_ghostObject) {
        btTransform c_transform = _ghostObject->getWorldTransform();
        btVector3 c_position = btVector3(position.x, position.y, position.z);
        c_transform.setOrigin(c_position);
        _ghostObject->setWorldTransform(c_transform);
    }
}

- (PKQuaternion)orientation {
    PKQuaternion output;
    if (_ghostObject) {
        btTransform c_transform = _ghostObject->getWorldTransform();
        btQuaternion c_orientation = c_transform.getRotation();
        output.x = c_orientation.x();
        output.y = c_orientation.y();
        output.z = c_orientation.z();
        output.w = c_orientation.w();
    }
    return output;
}

- (void)setOrientation:(PKQuaternion)orientation {
    if (_ghostObject) {
        
        btTransform c_transform = _ghostObject->getWorldTransform();
        
        btQuaternion c_orientation;
        c_orientation.setValue(orientation.x, orientation.y, orientation.z, orientation.w);
        
        c_transform.setRotation(c_orientation);
        _ghostObject->setWorldTransform(c_transform);
    }
}

// MARK: Collision

- (NSArray <PKBRigidBody *>*)internalGetCollidingRigidBodies {
    
    int numObjectsInGhost = 0;
    numObjectsInGhost = _ghostObject->getNumOverlappingObjects();
    
    NSMutableArray *collidingRigidBodies = [[NSMutableArray alloc] init];
    
    for (int i=0; i < numObjectsInGhost; i++) {
        btCollisionObject* c_colObj = _ghostObject->getOverlappingObject(i);
        PKBRigidBody* rigidBody = (__bridge PKBRigidBody*)c_colObj->getUserPointer();
        [collidingRigidBodies addObject:rigidBody];
    }
    
    return collidingRigidBodies;
    
}

@end
