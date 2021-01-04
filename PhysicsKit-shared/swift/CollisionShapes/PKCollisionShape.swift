//
//  PKCollisionShape.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation


/// An abstract protocol used by the various supported collision shapes. Collision shapes are used in detecting intersections within the physics simulation.
public protocol PKCollisionShape {
    
    /// The internal shape to pass around objc land
    var internalShape: PKBCollisionShape { get }
    
}
