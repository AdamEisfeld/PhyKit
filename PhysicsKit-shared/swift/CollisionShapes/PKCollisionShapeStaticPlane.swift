//
//  PKCollisionShapeStaticPlane.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// A collision shape of an infinite plane. These collision shapes should only be used for static rigid bodies.
public class PKCollisionShapeStaticPlane: PKCollisionShape {
    
    public let internalShape: PKBCollisionShape
    
    public init(direction: PKVector3 = PKVector3(0, 1, 0), transform: PKMatrix4 = PKMatrix4MakeIdentity(), margin: Float = 0.04) {
        internalShape = PKBCollisionShape(staticPlaneWithDirection: direction, transform: transform)
        internalShape.margin = margin
    }
    
    public required init(serializedData: Data) {
        internalShape = PKBCollisionShape(serializedData: serializedData)
    }
    
}
