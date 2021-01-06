//
//  PHYTriggerPair.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

public class PHYTriggerPair {
    
    public let rigidBody: PHYRigidBody
    public let trigger: PHYTrigger

    public init(rigidBody: PHYRigidBody, trigger: PHYTrigger) {
        self.rigidBody = rigidBody
        self.trigger = trigger
    }
    
}
