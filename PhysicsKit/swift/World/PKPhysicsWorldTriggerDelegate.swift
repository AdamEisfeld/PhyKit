//
//  PKPhysicsWorldTriggerDelegate.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation


public protocol PKPhysicsWorldTriggerDelegate: class {
    
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, triggerDidBeginAtTime time: TimeInterval, with collisionPair: PKTriggerPair)
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, triggerDidContinueAtTime time: TimeInterval, with collisionPair: PKTriggerPair)
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, triggerDidEndAtTime time: TimeInterval, with collisionPair: PKTriggerPair)
    
}
