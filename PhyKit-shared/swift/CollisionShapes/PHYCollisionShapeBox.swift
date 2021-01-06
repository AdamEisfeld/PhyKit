//
//  PHYCollisionShapeBox.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// A collision shape representing a box
public class PHYCollisionShapeBox: PHYCollisionShape {
    
    public let internalShape: CPHYCollisionShape
    
    public init(width: Float, height: Float, length: Float, transform: PHYMatrix4 = PHYMatrix4MakeIdentity(), margin: Float = 0.04) {
        internalShape = CPHYCollisionShape(boxWithWidth: width, height: height, length: length, transform: transform)
        internalShape.margin = margin
    }
    
    public init(size: Float, transform: PHYMatrix4 = PHYMatrix4MakeIdentity()) {
        internalShape = CPHYCollisionShape(boxWithWidth: size, height: size, length: size, transform: transform)
    }
    
}
