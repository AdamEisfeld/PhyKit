//
//  PHYSceneUpdateDelegate.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation
import SceneKit

// A delegate for receiving callbacks as a physics scene re-orients it's nodes to their corresponding rigid bodies
public protocol PHYSceneUpdateDelegate: AnyObject {
    
    func physicsSceneWillIterativelyUpdate(_ physicsScene: PHYScene)
    func physicsSceneDidIterativelyUpdate(_ physicsScene: PHYScene)
    func physicsScene(_ physicsScene: PHYScene, willReactivelyUpdateNode node: SCNNode, attachedToRigidBody rigidBody: PHYRigidBody)
    func physicsScene(_ physicsScene: PHYScene, didReactivelyUpdateNode node: SCNNode, attachedToRigidBody rigidBody: PHYRigidBody)
    
}
