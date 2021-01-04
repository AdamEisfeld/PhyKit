//
//  PKCollisionShapeCylinder.swift
//  PhysicsKit
//
//  Created by Adam Eisfeld on 2020-06-20.
//  Copyright © 2020 adameisfeld. All rights reserved.
//

import Foundation

/// A collision shape representing a cylinder
public class PKCollisionShapeCylinder: PKCollisionShape {
    
    public let internalShape: PKBCollisionShape
    
    public init(radius: Float, height: Float, transform: PKMatrix4 = PKMatrix4MakeIdentity(), margin: Float = 0.04) {
        internalShape = PKBCollisionShape(cylinderWithRadius: radius, height: height, transform: transform)
        internalShape.margin = margin
    }
    
    public required init(serializedData: Data) {
        internalShape = PKBCollisionShape(serializedData: serializedData)
    }
    
}
