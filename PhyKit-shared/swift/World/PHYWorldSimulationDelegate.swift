//
//  PHYWorldSimulationDelegate.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-11.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation


/// A delegate for receiving callbacks as a PHYWorld steps forward in it's simulation
public protocol PHYWorldSimulationDelegate: AnyObject {
    
    func physicsWorld(_ physicsWorld: PHYWorld, willSimulateAtTime time: TimeInterval)
    func physicsWorld(_ physicsWorld: PHYWorld, didSimulateAtTime time: TimeInterval)
    
}
