//
//  PKPhysicsWorldCollisionDelegate.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-11.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation


public protocol PKPhysicsWorldCollisionDelegate: class {
    
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, collisionDidBeginAtTime time: TimeInterval, with collisionPair: PKCollisionPair)
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, collisionDidContinueAtTime time: TimeInterval, with collisionPair: PKCollisionPair)
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, collisionDidEndAtTime time: TimeInterval, with collisionPair: PKCollisionPair)

}
