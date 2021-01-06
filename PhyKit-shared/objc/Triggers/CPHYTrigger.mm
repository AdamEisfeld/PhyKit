//
//  CPHYTrigger.m
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import "CPHYTrigger.h"
#import "CPHYTrigger+Internal.h"
#import "CPHYWorld.h"
#import "CPHYStructs.h"
#import "CPHYCollisionShape.h"
#import "CPHYCollisionShape+Internal.h"

@interface CPHYTrigger() {
    
    btCollisionShape* _c_shape;
    
}

@end

@implementation CPHYTrigger

// MARK: Initialization

- (instancetype)initWithCollisionShape: (CPHYCollisionShape *)collisionShape {
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
    [_physicsWorld internalRemoveTrigger:self];
    delete _ghostObject;
    delete _c_shape;
}

// MARK: Transform

- (PHYVector3)position {
    if (_ghostObject) {
        btTransform c_transform = _ghostObject->getWorldTransform();
        btVector3 c_position = c_transform.getOrigin();
        return PHYVector3Make(c_position.x(), c_position.y(), c_position.z());
    } else {
        return PHYVector3Make(0,0,0);
    }
}

- (void)setPosition:(PHYVector3)position {
    if (_ghostObject) {
        btTransform c_transform = _ghostObject->getWorldTransform();
        btVector3 c_position = btVector3(position.x, position.y, position.z);
        c_transform.setOrigin(c_position);
        _ghostObject->setWorldTransform(c_transform);
    }
}

- (PHYQuaternion)orientation {
    PHYQuaternion output;
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

- (void)setOrientation:(PHYQuaternion)orientation {
    if (_ghostObject) {
        
        btTransform c_transform = _ghostObject->getWorldTransform();
        
        btQuaternion c_orientation;
        c_orientation.setValue(orientation.x, orientation.y, orientation.z, orientation.w);
        
        c_transform.setRotation(c_orientation);
        _ghostObject->setWorldTransform(c_transform);
    }
}

// MARK: Collision

- (NSArray <CPHYRigidBody *>*)internalGetCollidingRigidBodies {
    
    int numObjectsInGhost = 0;
    numObjectsInGhost = _ghostObject->getNumOverlappingObjects();
    
    NSMutableArray *collidingRigidBodies = [[NSMutableArray alloc] init];
    
    for (int i=0; i < numObjectsInGhost; i++) {
        btCollisionObject* c_colObj = _ghostObject->getOverlappingObject(i);
        CPHYRigidBody* rigidBody = (__bridge CPHYRigidBody*)c_colObj->getUserPointer();
        [collidingRigidBodies addObject:rigidBody];
    }
    
    return collidingRigidBodies;
    
}

@end
