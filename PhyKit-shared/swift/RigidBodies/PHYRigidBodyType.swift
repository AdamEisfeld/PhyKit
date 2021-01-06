//
//  PHYRigidBodyType.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-11.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// The type of rigid body to use
public enum PHYRigidBodyType: Equatable {
    /// Static rigid bodies can not move or be affected by forces / collisions. Other rigid bodies can collide with static rigid bodies.
    case `static`
    /// Kinematic rigid bodies can be programmatically moved via their transform, but are not affected by forces / collisions. Other rigid bodies can collide with kinematic rigid bodies.
    case kinematic
    /// Dynamic rigid bodies are affected by forces / collisions and should not be programmatically moved via their transform. Apply forces to dynamic rigid bodies to move them.
    case dynamic(mass: Float)
    
    public static func ==(lhs: PHYRigidBodyType, rhs: PHYRigidBodyType) -> Bool {
        switch (lhs, rhs) {
        case (let .dynamic(lhsMass), let .dynamic(rhsMass)):
            return lhsMass == rhsMass
        case (.kinematic, .kinematic):
            return true
        case (.static, .static):
            return true
        default:
            return false
        }
    }
}

extension PHYRigidBodyType {
    
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
    
    public var isDynamic: Bool {
        self != .kinematic && self != .static
    }
    
    /// Static rigid bodies can not move or be affected by forces / collisions. Other rigid bodies can collide with static rigid bodies.
    public static var dynamic: PHYRigidBodyType {
        return .dynamic(mass: 1.0)
    }
    
    var internalType: CPHYRigidBodyType {
        switch self {
        case .static:
            return CPHYRigidBodyTypeStatic
        case .kinematic:
            return CPHYRigidBodyTypeKinematic
        default:
            return CPHYRigidBodyTypeDynamic
        }
    }
    
}
