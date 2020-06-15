//
//  PKCollisionShape.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation


public protocol PKCollisionShape {
    
    var internalShape: PKBCollisionShape { get }
    
}

public extension PKCollisionShape {
    
    func serialize() -> Data {
        return internalShape.serialize()
    }
    
}
