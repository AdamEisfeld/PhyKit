//
//  PKRigidBodyType.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-11.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation


public enum PKRigidBodyType {
    case `static`
    case kinematic
    case dynamic(mass: Float = 1.0)
}

extension PKRigidBodyType {
    
    public var mass: Float {
        switch self {
        case .static:
            return 0
        case .kinematic:
            return 0
        case .dynamic(let mass):
            return mass
        }
    }
    
    static var dynamic: PKRigidBodyType {
        return .dynamic(mass: 1.0)
    }
    
}
