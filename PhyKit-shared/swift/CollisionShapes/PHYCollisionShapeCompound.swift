//
//  PHYCollisionShapeCompound.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// A collision shape comprised of other collision shapes
public class PHYCollisionShapeCompound: PHYCollisionShape {
    
    public let internalShape: CPHYCollisionShape
    
    public init(collisionShapes: [PHYCollisionShape], transform: PHYMatrix4 = PHYMatrix4MakeIdentity(), margin: Float = 0.04) {
        let shapes = collisionShapes.map({$0.internalShape})
        internalShape = CPHYCollisionShape(collisionShapes: shapes, transform: transform)
        internalShape.margin = margin
    }
    
}
