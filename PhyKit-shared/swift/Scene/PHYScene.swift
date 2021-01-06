//
//  PHYScene.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation
import SceneKit

/// Scene instances provide an easy mechanism for wiring the transform of a RigidBody to the
/// transform of an SCNNode in SceneKit.
public class PHYScene {
    
    // MARK: - Public Properties
    
    /// An optional delegate for receiving callbacks as scenekit nodes are oriented to their associated rigid bodies
    public weak var delegate: PHYSceneUpdateDelegate?
    
    // MARK: - Private Properties
    
    private var attachmentsNodeToRigidBodies: [SCNNode : PHYRigidBody] = [:]
    private var attachmentsRigidBodiesToNodes: [PHYRigidBody : SCNNode] = [:]
    private let isMotionStateEnabled: Bool
    
    // MARK: - Public Functions
    
    /// Creates a new Scene
    /// - Parameter isMotionStateEnabled: If true, nodes will automatically have their transforms updated as their
    /// corresponding rigid bodies change their transform. If false, you must manually call
    /// iterativelyOrientAllNodesToAttachedRigidBodies() to re-orient the attached SCNNodes.
    public init(isMotionStateEnabled: Bool) {
        self.isMotionStateEnabled = isMotionStateEnabled
    }
    
    /// Attaches a rigid body to a scenekit node
    /// - Parameters:
    ///   - rigidBody: The rigid body to use as the source transform for the scenekit node
    ///   - node: The node to re-orient as the rigid body's transform changes
    public func attach(_ rigidBody: PHYRigidBody, to node: SCNNode) {
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
    
    /// Detaches a rigid body from a scenekit node
    /// - Parameter node: The node to detach
    public func detach(_ node: SCNNode) {
        if let rigidBody = attachmentsNodeToRigidBodies[node] {
            attachmentsRigidBodiesToNodes[rigidBody] = nil
            rigidBody.onSetVisualTransform = nil
            rigidBody.onGetVisualTransform = nil
        }
        attachmentsNodeToRigidBodies[node] = nil
    }
    
    /// Iterates over all nodes currently attached to rigid bodies in this scene, re-orienting them to their corresponding rigid body's transform
    public func iterativelyOrientAllNodesToAttachedRigidBodies() {
        delegate?.physicsSceneWillIterativelyUpdate(self)
        for (displayNode, rigidBody) in attachmentsNodeToRigidBodies {
            displayNode.position = rigidBody.position.scnVector3
            displayNode.orientation = rigidBody.orientation.scnQuaternion
        }
        delegate?.physicsSceneDidIterativelyUpdate(self)
    }
    
}
