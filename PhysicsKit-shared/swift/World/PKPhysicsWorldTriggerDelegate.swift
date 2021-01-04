//
//  PKPhysicsWorldTriggerDelegate.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// A delegate for receiving callbacks as a PKPhysicsWorld detects trigger zone interactions in it's simulation
public protocol PKPhysicsWorldTriggerDelegate: class {
    
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, triggerDidBeginAtTime time: TimeInterval, with collisionPair: PKTriggerPair)
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, triggerDidContinueAtTime time: TimeInterval, with collisionPair: PKTriggerPair)
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, triggerDidEndAtTime time: TimeInterval, with collisionPair: PKTriggerPair)
    
}
