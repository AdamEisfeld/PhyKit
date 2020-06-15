//
//  PKPhysicsScene.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation
import SceneKit


public class PKPhysicsScene {
    
    public weak var delegate: PKPhysicsSceneUpdateDelegate?
    
    private let scene: SCNScene
    private let physicsWorld: PKPhysicsWorld
    private var attachmentsNodeToRigidBodies: [SCNNode : PKRigidBody] = [:]
    private var attachmentsRigidBodiesToNodes: [PKRigidBody : SCNNode] = [:]
    private var nodes: Set<SCNNode> = []
    private var rigidBodies: Set<PKRigidBody> = []
    private let isMotionStateEnabled: Bool
    
    public init(scene: SCNScene, physicsWorld: PKPhysicsWorld, isMotionStateEnabled: Bool) {
        self.scene = scene
        self.physicsWorld = physicsWorld
        self.isMotionStateEnabled = isMotionStateEnabled
    }
    
    public func add(_ node: SCNNode) {
        if !nodes.contains(node) {
            nodes.insert(node)
            scene.rootNode.addChildNode(node)
        }
    }
    
    public func remove(_ node: SCNNode) {
        nodes.remove(node)
        node.removeFromParentNode()
        detach(node)
    }
    
    public func add(_ rigidBody: PKRigidBody) {
        if !rigidBodies.contains(rigidBody) {
            rigidBodies.insert(rigidBody)
            physicsWorld.add(rigidBody, for: UUID().uuidString)
        }
    }
    
    public func remove(_ rigidBody: PKRigidBody) {
        rigidBodies.remove(rigidBody)
        physicsWorld.remove(rigidBody)
        if let node = attachmentsRigidBodiesToNodes[rigidBody] {
            remove(node)
        }
    }
    
    public func attach(_ rigidBody: PKRigidBody, to node: SCNNode) {
        attachmentsNodeToRigidBodies[node] = rigidBody
        attachmentsRigidBodiesToNodes[rigidBody] = node
        node.transform = rigidBody.transform.scnMatrix
        guard isMotionStateEnabled else {
            return
        }
        rigidBody.onSetVisualTransform = { [weak self] transform in
            guard let `self` = self else { return }
            self.delegate?.physicsScene(self, willReactivelyUpdateNode: node, attachedToRigidBody: rigidBody)
            node.transform = transform.scnMatrix
            self.delegate?.physicsScene(self, didReactivelyUpdateNode: node, attachedToRigidBody: rigidBody)
        }
        
        rigidBody.onGetVisualTransform = {
            node.transform.blMatrix
        }
    }
    
    public func detach(_ node: SCNNode) {
        if let rigidBody = attachmentsNodeToRigidBodies[node] {
            attachmentsRigidBodiesToNodes[rigidBody] = nil
            rigidBody.onSetVisualTransform = nil
            rigidBody.onGetVisualTransform = nil
        }
        attachmentsNodeToRigidBodies[node] = nil
    }
    
    public func iterativelyOrientAllNodesToAttachedRigidBodies() {
        delegate?.physicsSceneWillIterativelyUpdate(self)
        for (displayNode, rigidBody) in attachmentsNodeToRigidBodies {
            displayNode.position = rigidBody.position.scnVector3
            displayNode.orientation = rigidBody.orientation.scnQuaternion
        }
        delegate?.physicsSceneDidIterativelyUpdate(self)
    }
    
}
