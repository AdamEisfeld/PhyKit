//
//  PKCollisionShapeCapsule.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// A collision shape representing a capsule
public class PKCollisionShapeCapsule: PKCollisionShape {
    
    public let internalShape: PKBCollisionShape
    
    public init(radius: Float, height: Float, transform: PKMatrix4 = PKMatrix4MakeIdentity(), margin: Float = 0.04) {
        internalShape = PKBCollisionShape(capsuleWithRadius: radius, height: height, transform: transform)
        internalShape.margin = margin
    }
    
    public required init(serializedData: Data) {
        internalShape = PKBCollisionShape(serializedData: serializedData)
    }
    
}
