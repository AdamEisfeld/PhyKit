//
//  PHYCollisionShapeCapsule.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// A collision shape representing a capsule
public class PHYCollisionShapeCapsule: PHYCollisionShape {
    
    public let internalShape: CPHYCollisionShape
    
    public init(radius: Float, height: Float, transform: PHYMatrix4 = PHYMatrix4MakeIdentity(), margin: Float = 0.04) {
        internalShape = CPHYCollisionShape(capsuleWithRadius: radius, height: height, transform: transform)
        internalShape.margin = margin
    }
    
    public required init(serializedData: Data) {
        internalShape = CPHYCollisionShape(serializedData: serializedData)
    }
    
}
