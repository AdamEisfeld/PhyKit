//
//  PHYWorldCollisionDelegate.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-11.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// A delegate for receiving callbacks as a PHYWorld detects collisions in it's simulation
public protocol PHYWorldCollisionDelegate: AnyObject {
    
    func physicsWorld(_ physicsWorld: PHYWorld, collisionDidBeginAtTime time: TimeInterval, with collisionPair: PHYCollisionPair)
    func physicsWorld(_ physicsWorld: PHYWorld, collisionDidContinueAtTime time: TimeInterval, with collisionPair: PHYCollisionPair)
    func physicsWorld(_ physicsWorld: PHYWorld, collisionDidEndAtTime time: TimeInterval, with collisionPair: PHYCollisionPair)

}
