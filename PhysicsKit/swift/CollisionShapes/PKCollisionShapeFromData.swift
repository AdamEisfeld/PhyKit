//
//  PKCollisionShapeFromData.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-14.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation


public class PKCollisionShapeFromData: PKCollisionShape {
    
    public let internalShape: PKBCollisionShape
    
    public init(serializedData: Data) {
        internalShape = PKBCollisionShape(serializedData: serializedData)
    }
    
}
