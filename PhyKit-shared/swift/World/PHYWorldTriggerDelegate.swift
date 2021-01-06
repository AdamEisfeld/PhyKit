//
//  PHYWorldTriggerDelegate.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// A delegate for receiving callbacks as a PHYWorld detects trigger zone interactions in it's simulation
public protocol PHYWorldTriggerDelegate: class {
    
    func physicsWorld(_ physicsWorld: PHYWorld, triggerDidBeginAtTime time: TimeInterval, with collisionPair: PHYTriggerPair)
    func physicsWorld(_ physicsWorld: PHYWorld, triggerDidContinueAtTime time: TimeInterval, with collisionPair: PHYTriggerPair)
    func physicsWorld(_ physicsWorld: PHYWorld, triggerDidEndAtTime time: TimeInterval, with collisionPair: PHYTriggerPair)
    
}
