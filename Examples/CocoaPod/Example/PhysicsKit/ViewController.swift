//
//  ViewController.swift
//  PhysicsKit
//
//  Created by AdamEisfeld on 06/15/2020.
//  Copyright (c) 2020 AdamEisfeld. All rights reserved.
//

import UIKit
import SceneKit
import PhysicsKit

class ViewController: UIViewController {

    let sceneView = SCNView()
    let camera = SCNCamera()
    let cameraNode = SCNNode()
    var sceneTime: TimeInterval?
    
    let physicsWorld = PKPhysicsWorld()
    lazy var physicsScene = PKPhysicsScene(scene: sceneView.scene!, physicsWorld: physicsWorld, isMotionStateEnabled: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSceneView()
        
        createCustom(scene: SCNScene(named: "scenes.scnassets/weirdMeshHole.scn")!,
                     position: .vector(0, 5, 0),
                     orientation: .euler(0, 0, 45, .degrees),
                     type: .dynamic(mass: 0.2))
        
        createBox(width: 100,
                  height: 1,
                  length: 100,
                  position: .vector(0, -10, 0),
                  orientation: .identity,
                  type: .static)
        
        physicsWorld.simulationDelegate = self
        physicsWorld.collisionDelegate = self
        physicsWorld.triggerDelegate = self
        
        physicsScene.delegate = self
        
    }
    
    private func setupSceneView() {
        let scene = SCNScene(named: "scenes.scnassets/world.scn")!
        sceneView.scene = scene
        
        cameraNode.camera = camera
        scene.rootNode.addChildNode(cameraNode)
        sceneView.pointOfView = cameraNode
        
        cameraNode.position = SCNVector3(0, 0, 20)
        
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sceneView)
        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        sceneView.isPlaying = true
        sceneView.delegate = self
        
    }
    
    private func createGroundPlane(position: PKVector3, orientation: PKQuaternion) {
        
        // Create a box
        let geometry = SCNBox(width: 100, height: 0.01, length: 100, chamferRadius: 0)
        let displayNode = SCNNode(geometry: geometry)
        
        // Create a physics body for the box
        let collisionShape = PKCollisionShapeStaticPlane()
        let rigidBody = PKRigidBody(type: .static, shape: collisionShape)
        
        rigidBody.position = position
        rigidBody.orientation = orientation
        
        physicsScene.add(displayNode)
        physicsScene.add(rigidBody)
        physicsScene.attach(rigidBody, to: displayNode)
    }
    
    private func createBox(width: Float, height: Float, length: Float, position: PKVector3, orientation: PKQuaternion, type: PKRigidBodyType) {
        
        // Create a box
        let geometry = SCNBox(width: CGFloat(width), height: CGFloat(height), length: CGFloat(length), chamferRadius: 0.0)
        let displayNode = SCNNode(geometry: geometry)
        
        // Create a physics body for the box
        let collisionShape = PKCollisionShapeBox(width: width, height: height, length: length)
        
        let data = collisionShape.serialize()
        let deserializedCollisionShape = PKCollisionShapeFromData(serializedData: data)
        
        let rigidBody = PKRigidBody(type: type, shape: deserializedCollisionShape)
        
        rigidBody.position = position
        rigidBody.orientation = orientation
        rigidBody.restitution = 0.8
        
        physicsScene.add(displayNode)
        physicsScene.add(rigidBody)
        physicsScene.attach(rigidBody, to: displayNode)
        
    }
    
    private func createCustom(scene: SCNScene, position: PKVector3, orientation: PKQuaternion, type: PKRigidBodyType) {
        
        // Load the geometry
        let displayNode = scene.rootNode.childNode(withName: "mesh", recursively: false)!
        let displayGeometry = displayNode.geometry!
        
        // Create a physics body for the geometry
        let physicsGeometry = PKGeometry(scnGeometry: displayGeometry)
        let collisionShape = PKCollisionShapeGeometry(geometry: physicsGeometry, type: .convex)
        
        let data = collisionShape.serialize()
        let deserializedCollisionShape = PKCollisionShapeFromData(serializedData: data)
        
        let rigidBody = PKRigidBody(type: type, shape: deserializedCollisionShape)
        
        rigidBody.position = position
        rigidBody.orientation = orientation
        rigidBody.restitution = 0.8
        
        physicsScene.add(displayNode)
        physicsScene.add(rigidBody)
        physicsScene.attach(rigidBody, to: displayNode)

    }
    
    private func createSphere(radius: Float, position: PKVector3, orientation: PKQuaternion, type: PKRigidBodyType) {
        
        // Create a sphere
        let geometry = SCNSphere(radius: 1.0)
        let displayNode = SCNNode(geometry: geometry)
        
        // Create a physics body for the sphere
        let collisionShape = PKCollisionShapeSphere(radius: radius)
        let rigidBody = PKRigidBody(type: type, shape: collisionShape)
        
        rigidBody.position = position
        //rigidBody.orientation = orientation
        rigidBody.restitution = 0.8
        
        physicsScene.add(displayNode)
        physicsScene.add(rigidBody)
        physicsScene.attach(rigidBody, to: displayNode)
        
    }

}

extension ViewController: PKPhysicsWorldSimulationDelegate {
    
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, willSimulateAtTime time: TimeInterval) {
        
    }
    
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, didSimulateAtTime time: TimeInterval) {
        
    }
    
}

extension ViewController: PKPhysicsWorldCollisionDelegate {
    
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, collisionDidBeginAtTime time: TimeInterval, with collisionPair: PKCollisionPair) {

    }
    
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, collisionDidContinueAtTime time: TimeInterval, with collisionPair: PKCollisionPair) {

    }
    
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, collisionDidEndAtTime time: TimeInterval, with collisionPair: PKCollisionPair) {
        
    }
    
}

extension ViewController: PKPhysicsWorldTriggerDelegate {
    
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, triggerDidBeginAtTime time: TimeInterval, with collisionPair: PKTriggerPair) {

    }
    
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, triggerDidContinueAtTime time: TimeInterval, with collisionPair: PKTriggerPair) {

    }
    
    func physicsWorld(_ physicsWorld: PKPhysicsWorld, triggerDidEndAtTime time: TimeInterval, with collisionPair: PKTriggerPair) {

    }
    
}

extension ViewController: SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        sceneTime = sceneTime ?? time
        let physicsTime = time - sceneTime!
        
        physicsWorld.simulationTime = physicsTime
        physicsScene.iterativelyOrientAllNodesToAttachedRigidBodies()
        
    }
    
}

extension ViewController: PKPhysicsSceneUpdateDelegate {
    
    func physicsSceneWillIterativelyUpdate(_ physicsScene: PKPhysicsScene) {
        
    }
    
    func physicsSceneDidIterativelyUpdate(_ physicsScene: PKPhysicsScene) {
        
    }
    
    func physicsScene(_ physicsScene: PKPhysicsScene, willReactivelyUpdateNode node: SCNNode, attachedToRigidBody rigidBody: PKRigidBody) {
        
    }
    
    func physicsScene(_ physicsScene: PKPhysicsScene, didReactivelyUpdateNode node: SCNNode, attachedToRigidBody rigidBody: PKRigidBody) {
        print("Dirty!")
    }
    
}
