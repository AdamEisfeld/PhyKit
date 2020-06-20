//
//  PKRigidBodyType.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-11.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// The type of rigid body to use
public enum PKRigidBodyType {
    /// Static rigid bodies can not move or be affected by forces / collisions. Other rigid bodies can collide with static rigid bodies.
    case `static`
    /// Kinemativ rigid bodies can be programmatically moved via their transform, but are not affected by forces / collisions. Other rigid bodies can collide with kinematic rigid bodies.
    case kinematic
    /// Dynamic rigid bodies are affected by forces / collisions and should not be programmatically moved via their transform. Apply forces to dynamic rigid bodies to move them.
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
    
    /// Static rigid bodies can not move or be affected by forces / collisions. Other rigid bodies can collide with static rigid bodies.
    static var dynamic: PKRigidBodyType {
        return .dynamic(mass: 1.0)
    }
    
    var internalType: PKBRigidBodyType {
        switch self {
        case .static:
            return PKBRigidBodyTypeStatic
        case .kinematic:
            return PKBRigidBodyTypeKinematic
        default:
            return PKBRigidBodyTypeDynamic
        }
    }
    
}
