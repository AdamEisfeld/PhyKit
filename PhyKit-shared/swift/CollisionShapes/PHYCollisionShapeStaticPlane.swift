//
//  PHYCollisionShapeStaticPlane.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// A collision shape of an infinite plane. These collision shapes should only be used for static rigid bodies.
public class PHYCollisionShapeStaticPlane: PHYCollisionShape {
    
    public let internalShape: CPHYCollisionShape
    
    public init(direction: PHYVector3 = PHYVector3(0, 1, 0), transform: PHYMatrix4 = PHYMatrix4MakeIdentity(), margin: Float = 0.04) {
        internalShape = CPHYCollisionShape(staticPlaneWithDirection: direction, transform: transform)
        internalShape.margin = margin
    }
    
    public required init(serializedData: Data) {
        internalShape = CPHYCollisionShape(serializedData: serializedData)
    }
    
}
