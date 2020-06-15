//
//  PKPhysicsSceneUpdateDelegate.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-13.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation
import SceneKit


public protocol PKPhysicsSceneUpdateDelegate: class {
    
    func physicsSceneWillIterativelyUpdate(_ physicsScene: PKPhysicsScene)
    func physicsSceneDidIterativelyUpdate(_ physicsScene: PKPhysicsScene)
    func physicsScene(_ physicsScene: PKPhysicsScene, willReactivelyUpdateNode node: SCNNode, attachedToRigidBody rigidBody: PKRigidBody)
    func physicsScene(_ physicsScene: PKPhysicsScene, didReactivelyUpdateNode node: SCNNode, attachedToRigidBody rigidBody: PKRigidBody)
    
}
