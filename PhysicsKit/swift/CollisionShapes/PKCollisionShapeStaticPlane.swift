//
//  PKCollisionShapeStaticPlane.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation


public class PKCollisionShapeStaticPlane: PKCollisionShape {
    
    public let internalShape: PKBCollisionShape
    
    public init(direction: PKVector3 = PKVector3(0, 1, 0), transform: PKMatrix4 = PKMatrix4MakeIdentity()) {
        internalShape = PKBCollisionShape(staticPlaneWithDirection: direction, transform: transform)
    }
    
    public required init(serializedData: Data) {
        internalShape = PKBCollisionShape(serializedData: serializedData)
    }
    
}
