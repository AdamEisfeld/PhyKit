//
//  PKCollisionShapeBox.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// A collision shape representing a box
public class PKCollisionShapeBox: PKCollisionShape {
    
    public let internalShape: PKBCollisionShape
    
    public init(width: Float, height: Float, length: Float, transform: PKMatrix4 = PKMatrix4MakeIdentity()) {
        internalShape = PKBCollisionShape(boxWithWidth: width, height: height, length: length, transform: transform)
    }
    
    public init(size: Float, transform: PKMatrix4 = PKMatrix4MakeIdentity()) {
        internalShape = PKBCollisionShape(boxWithWidth: size, height: size, length: size, transform: transform)
    }
    
}
