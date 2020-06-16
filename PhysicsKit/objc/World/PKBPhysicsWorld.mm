//
//  PKBPhysicsWorld.mm
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-10.
//  Copyright © 2020 adam. All rights reserved.
//

#import "PKBPhysicsWorld.h"

#import "PKBRigidBody.h"
#import "PKBRigidBody+Internal.h"
#import "PKBPhysicsTrigger.h"
#import "PKBPhysicsTrigger+Internal.h"

#import <SceneKit/SceneKit.h>

#import "PKBDependencies+Internal.h"

@implementation PKBPhysicsWorld {
    
    btBroadphaseInterface*                  _broadphase;
    btDefaultCollisionConfiguration*        _collisionConfiguration;
    btCollisionDispatcher*                  _dispatcher;
    btSequentialImpulseConstraintSolver*    _solver;
    btDiscreteDynamicsWorld*                _world;
    
}

// MARK: Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializePhysics];
    }
    return self;
}

- (void)initializePhysics {
    
//    Collision detection is done in two phases: broad and narrow. In the broad phase, the physics engine quickly eliminates objects that cannot collide. For example, it can run a quick check to using the bounding boxes of objects, eliminating those that don’t collide. It then passes only a small list of objects that can collide to the narrow phase, which is much slower, since it checks actual shapes for collision.
//    Bullet has several built-in implementations of the broad phase. In this tutorial, you’re using the dynamic AABB tree implementation – i.e. btDbvtBroadphase.
    _broadphase = new btDbvtBroadphase();
    
    // Enable ghost objects
    _broadphase->getOverlappingPairCache()->setInternalGhostPairCallback(new btGhostPairCallback());
    
//    collisionConfiguration is responsible for full, not broad, collision detection. In other words, this is where the more fine-grained and accurate collision detection code runs. You could create your own implementation, but for now you’re using the built-in configuration again.
    _collisionConfiguration = new btDefaultCollisionConfiguration();
    _dispatcher = new btCollisionDispatcher(_collisionConfiguration);
    
//    This is what causes the objects to interact properly, taking into account gravity, game logic supplied forces, collisions, and hinge constraints. It does a good job as long as you don’t push it to extremes, and is one of the bottlenecks in any high performance simulation. There are parallel versions available for some threading models.
    _solver = new btSequentialImpulseConstraintSolver();
    
//    Finally you create the world, passing in the configuration options you created earlier.
    _world = new btDiscreteDynamicsWorld(_dispatcher, _broadphase, _solver, _collisionConfiguration);
    
//    The last step is to set the world’s gravity. For now, it will be same gravity as we have here on Earth. The y-vector points up, so btVector3(0, -9.8, 0), which is a 3-component vector (x,y,z), will point down with a magnitude of 9.8.
    _world->setGravity(btVector3(0, -9.8, 0));
    
    //_world->getSolverInfo().m_splitImpulse = false;
}

// MARK: Updates

- (void)internalAddRigidBody: (PKBRigidBody *)rigidBody {
    _world->addRigidBody(rigidBody.c_body);
    rigidBody.physicsWorld = self;
}

- (void)internalRemoveRigidBody: (PKBRigidBody *)rigidBody {
    _world->removeRigidBody(rigidBody.c_body);
    rigidBody.physicsWorld = nil;
}

- (void)internalAddPhysicsTrigger: (PKBPhysicsTrigger *)physicsTrigger {
    _world->addCollisionObject(physicsTrigger.ghostObject);
    physicsTrigger.physicsWorld = self;
}

- (void)internalRemovePhysicsTrigger: (PKBPhysicsTrigger *)physicsTrigger {
    _world->removeCollisionObject(physicsTrigger.ghostObject);
    physicsTrigger.physicsWorld = nil;
}

- (void)internalStepSimulation: (NSTimeInterval)time {
    _world->stepSimulation(time, 1, 1 / 60.0f);
}

// MARK: Collisions

- (void)internalCheckCollisions {
    
    // Get all contact manifolds. A contact manifold is a cache that contains all contact points between pairs of collision objects.
    int numManifolds = _world->getDispatcher()->getNumManifolds();
    
    // Iterate each manifold
    for (int i = 0; i < numManifolds; i ++) {
        
        // Extract the manifold
        btPersistentManifold* contactManifold =  _world->getDispatcher()->getManifoldByIndexInternal(i);

        int numContacts = contactManifold->getNumContacts();
        
        // The existance of a manifold does not mean a collision is occuring RIGHT NOW. We
        // need to check if the number of contacts is greater than 0 to determine if
        // a collision is actually occuring right now.
        if (numContacts > 0) {
            
            // Extract the two objects that collided
            const btCollisionObject* c_colObjA = contactManifold->getBody0();
            const btCollisionObject* c_colObjB = contactManifold->getBody1();

            btManifoldPoint contactPoint = contactManifold->getContactPoint(0);
            
            // Compute Local Positions
            btVector3 c_localPositionA = contactPoint.m_localPointA;
            btVector3 c_localPositionB = contactPoint.m_localPointB;
            SCNVector3 localPositionA = SCNVector3Make(c_localPositionA.x(), c_localPositionA.y(), c_localPositionA.z());
            SCNVector3 localPositionB = SCNVector3Make(c_localPositionB.x(), c_localPositionB.y(), c_localPositionB.z());
            
            // Extract the user pointers from these collision objects so we can derive the
            // associated PKBRigidBodys
            PKBRigidBody* rigidBodyA = (__bridge PKBRigidBody*)c_colObjA->getUserPointer();
            PKBRigidBody* rigidBodyB = (__bridge PKBRigidBody*)c_colObjB->getUserPointer();
            
            // Signal a collision
            [self internalCollisionDidOccur:rigidBodyA localPositionA:localPositionA internalRigidBodyB:rigidBodyB localPositionB:localPositionB];
            
        }
        
    }
    
}

- (void)internalCollisionDidOccur:(PKBRigidBody *)internalRigidBodyA localPositionA:(SCNVector3)pointA internalRigidBodyB:(PKBRigidBody *)internalRigidBodyB localPositionB:(SCNVector3)pointB {
    // Subclass overrides
}

// MARK: Accessors

- (SCNVector3)gravity {
    btVector3 c_gravity = _world->getGravity();
    return SCNVector3Make(c_gravity.x(), c_gravity.y(), c_gravity.z());
}

- (void)setGravity:(SCNVector3)gravity {
    btVector3 c_gravity = btVector3(gravity.x, gravity.y, gravity.z);
    _world->setGravity(c_gravity);
}

// MARK: Deallocation

- (void)dealloc {
//    And as a final step, you need to free the storage of everything created with the C++ new operator. Remember, things you allocate with new are not managed by ARC – it’s up to you! So add a dealloc method:
    delete _world;
    delete _solver;
    delete _collisionConfiguration;
    delete _dispatcher;
    delete _broadphase;
}

- (void)internalReset {
    
    // Clean the broadphase of AABB data
    btOverlappingPairCache *pairs = _broadphase->getOverlappingPairCache();
    
    int numPairs = pairs->getNumOverlappingPairs();
    btBroadphasePairArray pairArray = pairs->getOverlappingPairArray();
    for (int x = 0; x < numPairs; x ++) {
        btBroadphasePair &currPair = pairArray.at(x);
        pairs->cleanOverlappingPair(currPair, _dispatcher);
        pairs->removeOverlappingPair(currPair.m_pProxy0, currPair.m_pProxy1, _dispatcher);
    }
    
    // Clean the dispatcher(narrowphase) of shape data
    int numMainfolds = _dispatcher->getNumManifolds();
    for (int i = 0; i < numMainfolds; i ++) {
        _dispatcher->releaseManifold(_dispatcher->getManifoldByIndexInternal(i));
    }
    
    _broadphase->resetPool(_dispatcher);
    _solver->reset();
    _world->stepSimulation(1.f/60.f,1,1.f/60.f);
    
}

@end
