//
//  PKCollisionShapeSphere.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// A collision shape representing a sphere
public class PKCollisionShapeSphere: PKCollisionShape {
    
    public let internalShape: PKBCollisionShape
    
    public init(radius: Float, transform: PKMatrix4 = PKMatrix4MakeIdentity(), margin: Float = 0.04) {
        internalShape = PKBCollisionShape(sphereWithRadius: radius, transform: transform)
        internalShape.margin = margin
    }
    
    public required init(serializedData: Data) {
        internalShape = PKBCollisionShape(serializedData: serializedData)
    }
    
}
