//
//  PKCollisionShapeCapsule.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation


public class PKCollisionShapeCapsule: PKCollisionShape {
    
    public let internalShape: PKBCollisionShape
    
    public init(radius: Float, height: Float, transform: PKMatrix4 = PKMatrix4MakeIdentity()) {
        internalShape = PKBCollisionShape(capsuleWithRadius: radius, height: height, transform: transform)
    }
    
    public required init(serializedData: Data) {
        internalShape = PKBCollisionShape(serializedData: serializedData)
    }
    
}
