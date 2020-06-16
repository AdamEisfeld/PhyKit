//
//  PKCollisionShapeGeometry.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation

/// A collision shape constructed from custom geometry
public class PKCollisionShapeGeometry: PKCollisionShape {
    
    public enum PKCollisionShapeGeometryType {
        case convex
        case concave
    }
    
    public let internalShape: PKBCollisionShape
    
    public init(geometry: PKGeometry, type: PKCollisionShapeGeometryType) {
        
        let internalGeometry = geometry.internalGeometry
        
        switch type {
        case .convex:
            internalShape = PKBCollisionShape(convexHullWith: internalGeometry)
        case .concave:
            internalShape = PKBCollisionShape(triangleMeshWith: internalGeometry)
        }
    }
    
}
