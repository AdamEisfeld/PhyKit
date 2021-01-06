//
//  PHYCollisionShapeGeometry.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation
import SceneKit

/// A collision shape constructed from custom geometry
public class PHYCollisionShapeGeometry: PHYCollisionShape {
    
    public enum PHYCollisionShapeGeometryType {
        case convex
        case concave
    }
    
    public let internalShape: CPHYCollisionShape
    
    public init(geometry: PHYGeometry, type: PHYCollisionShapeGeometryType, transform: PHYMatrix4 = PHYMatrix4MakeIdentity(), margin: Float = 0.04) {
        
        let internalGeometry = geometry.internalGeometry
        
        switch type {
        case .convex:
            internalShape = CPHYCollisionShape(convexHullWith: internalGeometry, transform: transform)
        case .concave:
            internalShape = CPHYCollisionShape(triangleMeshWith: internalGeometry, transform: transform)
        }
        internalShape.margin = margin
        
    }
    
}
