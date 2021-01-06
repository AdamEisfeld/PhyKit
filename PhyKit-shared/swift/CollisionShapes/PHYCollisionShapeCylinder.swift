//
//  PHYCollisionShapeCylinder.swift
//  PhyKit
//
//  Created by Adam Eisfeld on 2020-06-20.
//  Copyright © 2020 adameisfeld. All rights reserved.
//

import Foundation

/// A collision shape representing a cylinder
public class PHYCollisionShapeCylinder: PHYCollisionShape {
    
    public let internalShape: CPHYCollisionShape
    
    public init(radius: Float, height: Float, transform: PHYMatrix4 = PHYMatrix4MakeIdentity(), margin: Float = 0.04) {
        internalShape = CPHYCollisionShape(cylinderWithRadius: radius, height: height, transform: transform)
        internalShape.margin = margin
    }
    
    public required init(serializedData: Data) {
        internalShape = CPHYCollisionShape(serializedData: serializedData)
    }
    
}
