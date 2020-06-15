//
//  PKCollisionShapeCompound.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation


public class PKCollisionShapeCompound: PKCollisionShape {
    
    public let internalShape: PKBCollisionShape
    
    public init(collisionShapes: [PKCollisionShape], transform: PKMatrix4 = PKMatrix4MakeIdentity()) {
        let shapes = collisionShapes.map({$0.internalShape})
        internalShape = PKBCollisionShape(collisionShapes: shapes, transform: transform)
    }
    
}
