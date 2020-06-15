//
//  PKTriggerPair.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

public class PKTriggerPair {
    
    public let rigidBody: PKRigidBody
    public let trigger: PKTrigger

    public init(rigidBody: PKRigidBody, trigger: PKTrigger) {
        self.rigidBody = rigidBody
        self.trigger = trigger
    }
    
}
