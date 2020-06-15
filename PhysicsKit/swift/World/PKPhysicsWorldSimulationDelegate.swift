//
//  PKPhysicsWorldSimulationDelegate.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-11.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation


public protocol PKPhysicsWorldSimulationDelegate: class {
    
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, willSimulateAtTime time: TimeInterval)
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, didSimulateAtTime time: TimeInterval)
    
}
