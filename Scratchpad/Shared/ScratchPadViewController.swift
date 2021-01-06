//
//  ScratchPadViewController.swift
//  ScratchPad
//
//  Created by Adam Eisfeld on 2021-01-06.
//

import Foundation
import PhyKit

/// This project implements the boiler-plate code for setting up a SceneKit
/// scene wired to PhyKit. Use this project to test PhyKit, implement
/// new features, and debug issues. Ensure any changes you make to this
/// project (aside for general improvements) are not commited.
public class ScratchPadViewController: BridgeViewController {
    
    private let sceneView = SCNView()
    private var sceneTime: TimeInterval?
    private let physicsWorld = PHYWorld()
    private lazy var physicsScene = PHYScene(isMotionStateEnabled: false)
    
    public override func loadView() {
        self.view = BridgeView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView(sceneName: "world")
        setupWorld()
    }
    
    private func setupSceneView(sceneName: String) {
            
        let scene = SCNScene(named: "Scenes.scnassets/\(sceneName).scn")!
        sceneView.scene = scene
        let cameraNode = SCNNode()
        let camera = SCNCamera()
        camera.zFar = 1000
        cameraNode.camera = camera
        sceneView.pointOfView = cameraNode
        cameraNode.position = SCNVector3(0,20,100)
        sceneView.allowsCameraControl = true
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.defaultCameraController.target = SCNVector3(0,20,0)
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
    
    private func setupWorld() {
        physicsWorld.simulationDelegate = self
        physicsWorld.collisionDelegate = self
        physicsWorld.triggerDelegate = self
        physicsScene.delegate = self
    }
    
}

extension ScratchPadViewController: PHYWorldSimulationDelegate {
    
    public func physicsWorld(_ physicsWorld: PHYWorld, willSimulateAtTime time: TimeInterval) {
        
    }
    
    public func physicsWorld(_ physicsWorld: PHYWorld, didSimulateAtTime time: TimeInterval) {
        
    }
    
}

extension ScratchPadViewController: PHYWorldCollisionDelegate {
    
    public func physicsWorld(_ physicsWorld: PHYWorld, collisionDidBeginAtTime time: TimeInterval, with collisionPair: PHYCollisionPair) {

    }
    
    public func physicsWorld(_ physicsWorld: PHYWorld, collisionDidContinueAtTime time: TimeInterval, with collisionPair: PHYCollisionPair) {

    }
    
    public func physicsWorld(_ physicsWorld: PHYWorld, collisionDidEndAtTime time: TimeInterval, with collisionPair: PHYCollisionPair) {
        
    }
    
}

extension ScratchPadViewController: PHYWorldTriggerDelegate {
    
    public func physicsWorld(_ physicsWorld: PHYWorld, triggerDidBeginAtTime time: TimeInterval, with collisionPair: PHYTriggerPair) {

    }
    
    public func physicsWorld(_ physicsWorld: PHYWorld, triggerDidContinueAtTime time: TimeInterval, with collisionPair: PHYTriggerPair) {

    }
    
    public func physicsWorld(_ physicsWorld: PHYWorld, triggerDidEndAtTime time: TimeInterval, with collisionPair: PHYTriggerPair) {

    }
    
}

extension ScratchPadViewController: SCNSceneRendererDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {

        sceneTime = sceneTime ?? time
        let physicsTime = time - sceneTime!
        
        physicsWorld.simulationTime = physicsTime
        physicsScene.iterativelyOrientAllNodesToAttachedRigidBodies()
        
    }
    
}

extension ScratchPadViewController: PHYSceneUpdateDelegate {
    
    public func physicsSceneWillIterativelyUpdate(_ physicsScene: PHYScene) {
        
    }
    
    public func physicsSceneDidIterativelyUpdate(_ physicsScene: PHYScene) {
        
    }
    
    public func physicsScene(_ physicsScene: PHYScene, willReactivelyUpdateNode node: SCNNode, attachedToRigidBody rigidBody: PHYRigidBody) {
        
    }
    
    public func physicsScene(_ physicsScene: PHYScene, didReactivelyUpdateNode node: SCNNode, attachedToRigidBody rigidBody: PHYRigidBody) {
        print("Dirty!")
    }
    
}
