//
//  PHYCollisionShapeSphere.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// A collision shape representing a sphere
public class PHYCollisionShapeSphere: PHYCollisionShape {
    
    public let internalShape: CPHYCollisionShape
    
    public init(radius: Float, transform: PHYMatrix4 = PHYMatrix4MakeIdentity(), margin: Float = 0.04) {
        internalShape = CPHYCollisionShape(sphereWithRadius: radius, transform: transform)
        internalShape.margin = margin
    }
    
    public required init(serializedData: Data) {
        internalShape = CPHYCollisionShape(serializedData: serializedData)
    }
    
}
