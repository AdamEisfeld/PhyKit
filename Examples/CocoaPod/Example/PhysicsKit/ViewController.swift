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

    // A SceneKit view for rendering our scene
    let sceneView = SCNView()
    
    // The current scene time to use for our physics simulation
    var sceneTime: TimeInterval?
    
    // A physics world for simulating physics
    let physicsWorld = PKPhysicsWorld()
    
    // A physics scene for attaching rigid bodies to scenekit nodes
    lazy var physicsScene = PKPhysicsScene(isMotionStateEnabled: false)
    
    // Represents one of our spawned rigid body / node pairs
    typealias SpawnedNode = (rigidBody: PKRigidBody, displayNode: SCNNode)
    private var spawnedNodes: [String : SpawnedNode] = [:]
    private var lastSpawnTime: Date = Date()
    
    // MARK: Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Embed an SCNView in our VC's view, loading a basic scene
        setupSceneView(sceneName: "world")
        
        // Setup our physics world
        setupPhysicsWorld()
        
        // Create a static ground object for our objects to bounce off of
        createGroundPedastle(position: .vector(0, -10, 0), orientation: .identity)
        
        // Create a kinematic logo object that we'll move around to interact with the scene
        createLogo()
        
    }
    
    private func setupSceneView(sceneName: String) {
        
        let scene = SCNScene(named: "scenes.scnassets/\(sceneName).scn")!
        sceneView.scene = scene
        
        let cameraOrbit = SCNNode()
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        camera.zFar = 1000
        cameraNode.camera = camera
        scene.rootNode.addChildNode(cameraNode)
        sceneView.pointOfView = cameraNode
        
        cameraNode.position = SCNVector3(0, 15, -60)
        cameraNode.look(at: SCNVector3Zero)
        cameraOrbit.addChildNode(cameraNode)
        
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
        
        scene.rootNode.addChildNode(cameraOrbit)

    }
    
    private func setupPhysicsWorld() {
        physicsWorld.simulationDelegate = self
        physicsWorld.collisionDelegate = self
        physicsWorld.triggerDelegate = self
        physicsScene.delegate = self
    }
    
    // MARK: Spawning
    
    /// Spawns a random rigid body into the scene
    private func spawnRandomRigidBody() {
        
        let primitiveTypes: [String] = [
            "box", "sphere", "capsule", "cylinder"
        ]
        
        let primitiveTypeIndex = Int.random(in: 0..<primitiveTypes.count)
        let primitiveType = primitiveTypes[primitiveTypeIndex]
        
        let position: PKVector3 = .vector(Float.random(in: -10..<10), Float.random(in: 30..<Float(50)), Float.random(in: -10..<10))
        let oritentation: PKQuaternion = .euler(Float.random(in: 0..<360), Float.random(in: 0..<360), Float.random(in: 0..<360), .degrees)
        
        let spawnedNode: SpawnedNode
        
        switch primitiveType {
        case "box":
            spawnedNode = createBox(width: Float.random(in: 1..<3), height: Float.random(in: 1..<3), length: Float.random(in: 1..<3), position: position, orientation: oritentation, type: .dynamic)
        case "sphere":
            spawnedNode = createSphere(radius: Float.random(in: 1..<3), position: position, orientation: oritentation, type: .dynamic)
        case "capsule":
            spawnedNode = createCapsule(radius: Float.random(in: 1..<1.5), height: Float.random(in: 5..<10), position: position, orientation: oritentation, type: .dynamic)
        case "cylinder":
            spawnedNode = createCylinder(radius: Float.random(in: 1..<1.5), height: Float.random(in: 5..<10), position: position, orientation: oritentation, type: .dynamic)
        default:
            fatalError()
        }
        
        let identifier = UUID().uuidString
        spawnedNodes[identifier] = spawnedNode

    }
    
    private func spawnRigidBodies() {
        
        // Remove any bodies that have fallen too far below the ground
        
        for (identifier, spawnedNode) in spawnedNodes {
            if spawnedNode.rigidBody.position.y < -50 {

                physicsWorld.remove(spawnedNode.rigidBody)
                physicsScene.detach(spawnedNode.displayNode)
                
                spawnedNode.displayNode.removeFromParentNode()
                
                spawnedNodes[identifier] = nil
            }
        }
        
        // Spawn more rigid bodies if we need to
        
        if lastSpawnTime.timeIntervalSinceNow < -0.2, spawnedNodes.count < 100 {
            spawnRandomRigidBody()
            lastSpawnTime = Date()
        }
        
    }
    
    // MARK: Body/Node Creation
    
    private func createLogo() {
        
        let collisionScene = SCNScene(named: "scenes.scnassets/pkLogo_collision.scn")!
        let collisionNode = collisionScene.rootNode.childNode(withName: "logo", recursively: true)!
        var collisionShapes: [PKCollisionShape] = []
        for displayNode in collisionNode.childNodes {
            let displayGeometry = displayNode.geometry!
            let physicsGeometry = PKGeometry(scnGeometry: displayGeometry)
            let collisionShape = PKCollisionShapeGeometry(geometry: physicsGeometry, type: .convex)
            collisionShapes.append(collisionShape)
        }
        let collisionShape = PKCollisionShapeCompound(collisionShapes: collisionShapes)
        
        let scene = SCNScene(named: "scenes.scnassets/pkLogo_visual.scn")!
        let displayNode = scene.rootNode.childNode(withName: "logo", recursively: true)!
        
        let rigidBody = PKRigidBody(type: .kinematic, shape: collisionShape)

        rigidBody.position = .zero
        rigidBody.restitution = 0.8
        rigidBody.isSleepingEnabled = false
        rigidBody.position = .vector(0, -1, 0)
        
        // Create an action that moves the logo up/down via a sinewave
        var inc: Float = 0
        let moveAction = PKAction.move(rigidBody, byFunction: { () -> (PKVector3) in
            let y = sin(inc)
            inc += 0.02
            return .vector(0, y * 0.1, 0)
        })
        moveAction.repeatCount = -1
        
        // Create an action that rotates the logo constantly around it's y axis
        let orientAction = PKAction.orient(rigidBody, by: .euler(0, 180, 0, .degrees), duration: 4.0)
        orientAction.repeatCount = -1
        
        // Run the actions
        moveAction.run()
        orientAction.run()

        physicsWorld.add(rigidBody)
        sceneView.scene!.rootNode.addChildNode(displayNode)
        physicsScene.attach(rigidBody, to: displayNode)
        
    }
    
    private func createGroundPedastle(position: PKVector3, orientation: PKQuaternion) {
        // Create a box
        let geometry = SCNCylinder(radius: 14, height: 2)
        let displayNode = SCNNode(geometry: geometry)
        
        // Color the geometry
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        material.lightingModel = .physicallyBased
        geometry.materials = [material]
        
        // Create a physics body for the box
        let collisionShape = PKCollisionShapeCylinder(radius: 14, height: 2)
        let rigidBody = PKRigidBody(type: .static, shape: collisionShape)
        
        rigidBody.position = position
        rigidBody.orientation = orientation
        rigidBody.isSleepingEnabled = false
        
        physicsWorld.add(rigidBody)
        sceneView.scene!.rootNode.addChildNode(displayNode)
        physicsScene.attach(rigidBody, to: displayNode)
    }
    
    private func createGroundPlane(position: PKVector3, orientation: PKQuaternion) {
        
        // Create a box
        let geometry = SCNFloor()
        let displayNode = SCNNode(geometry: geometry)
        
        // Color the geometry
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        material.lightingModel = .physicallyBased
        geometry.materials = [material]
        
        // Create a physics body for the box
        let collisionShape = PKCollisionShapeStaticPlane()
        let rigidBody = PKRigidBody(type: .static, shape: collisionShape)
        
        rigidBody.position = position
        rigidBody.orientation = orientation
        rigidBody.isSleepingEnabled = false
        
        physicsWorld.add(rigidBody)
        sceneView.scene!.rootNode.addChildNode(displayNode)
        physicsScene.attach(rigidBody, to: displayNode)
        
    }
    
    private func createBox(width: Float, height: Float, length: Float, position: PKVector3, orientation: PKQuaternion, type: PKRigidBodyType) -> SpawnedNode  {
        
        // Create a box
        let geometry = SCNBox(width: CGFloat(width), height: CGFloat(height), length: CGFloat(length), chamferRadius: 0.0)
        let displayNode = SCNNode(geometry: geometry)
        
        // Color the geometry
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 235.0/255.0, green: 64.0/255.0, blue: 52.0/255.0, alpha: 1.0)
        material.lightingModel = .physicallyBased
        geometry.materials = [material]
        
        // Create a physics body for the box
        let collisionShape = PKCollisionShapeBox(width: width, height: height, length: length)
        
        let rigidBody = PKRigidBody(type: type, shape: collisionShape)
        rigidBody.position = position
        rigidBody.orientation = orientation
        rigidBody.restitution = 0.8
        rigidBody.isSleepingEnabled = false
        
        physicsWorld.add(rigidBody)
        sceneView.scene!.rootNode.addChildNode(displayNode)
        physicsScene.attach(rigidBody, to: displayNode)
        
        return SpawnedNode(rigidBody, displayNode)
        
    }
    
    private func createSphere(radius: Float, position: PKVector3, orientation: PKQuaternion, type: PKRigidBodyType) -> SpawnedNode  {
        
        // Create a sphere
        let geometry = SCNSphere(radius: CGFloat(radius))
        let displayNode = SCNNode(geometry: geometry)
        
        // Color the geometry
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 52.0/255.0, green: 174.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        material.lightingModel = .physicallyBased
        geometry.materials = [material]
        
        // Create a physics body for the sphere
        let collisionShape = PKCollisionShapeSphere(radius: radius)
        let rigidBody = PKRigidBody(type: type, shape: collisionShape)
        
        rigidBody.position = position
        rigidBody.orientation = orientation
        rigidBody.restitution = 0.8
        rigidBody.isSleepingEnabled = false
        
        physicsWorld.add(rigidBody)
        sceneView.scene!.rootNode.addChildNode(displayNode)
        physicsScene.attach(rigidBody, to: displayNode)
        
        return SpawnedNode(rigidBody, displayNode)
        
    }
    
    private func createCapsule(radius: Float, height: Float, position: PKVector3, orientation: PKQuaternion, type: PKRigidBodyType) -> SpawnedNode  {
        
        // Create a sphere
        let geometry = SCNCapsule(capRadius: CGFloat(radius), height: CGFloat(height))
        let displayNode = SCNNode(geometry: geometry)
        
        // Color the geometry
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 201.0/255.0, green: 52.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        material.lightingModel = .physicallyBased
        geometry.materials = [material]
        
        // Create a physics body for the sphere
        let collisionShape = PKCollisionShapeCapsule(radius: radius, height: height)
        let rigidBody = PKRigidBody(type: type, shape: collisionShape)
        
        rigidBody.position = position
        rigidBody.orientation = orientation
        rigidBody.restitution = 0.8
        rigidBody.isSleepingEnabled = false
        
        physicsWorld.add(rigidBody)
        sceneView.scene!.rootNode.addChildNode(displayNode)
        physicsScene.attach(rigidBody, to: displayNode)
        
        return SpawnedNode(rigidBody, displayNode)
        
    }
    
    private func createCylinder(radius: Float, height: Float, position: PKVector3, orientation: PKQuaternion, type: PKRigidBodyType) -> SpawnedNode  {
        
        // Create a sphere
        let geometry = SCNCylinder(radius: CGFloat(radius), height: CGFloat(height))
        let displayNode = SCNNode(geometry: geometry)
        
        // Color the geometry
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 186.0/255.0, green: 235.0/255.0, blue: 52.0/255.0, alpha: 1.0)
        material.lightingModel = .physicallyBased
        geometry.materials = [material]
        
        // Create a physics body for the sphere
        let collisionShape = PKCollisionShapeCylinder(radius: radius, height: height)
        let rigidBody = PKRigidBody(type: type, shape: collisionShape)
        
        rigidBody.position = position
        rigidBody.orientation = orientation
        rigidBody.restitution = 0.8
        rigidBody.isSleepingEnabled = false
        
        physicsWorld.add(rigidBody)
        sceneView.scene!.rootNode.addChildNode(displayNode)
        physicsScene.attach(rigidBody, to: displayNode)
        
        return SpawnedNode(rigidBody, displayNode)
        
    }
    
    // MARK: Touch Interaction
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    private func checkTouches(_ touches: Set<UITouch>) {
        let touchLocation = touches.first?.location(in: view) ?? .zero
        let unprojectStart = SCNVector3(touchLocation.x, touchLocation.y, 0)
        let unprojectEnd = SCNVector3(touchLocation.x, touchLocation.y, 1)
        
        // Convert the 2D touch location to a 3D point on the camera's near plane
        let rayStart = sceneView.unprojectPoint(unprojectStart).PKVector3
        // Convert the 2D touch location to a 3D point on the camera's far plane
        let rayEnd = sceneView.unprojectPoint(unprojectEnd).PKVector3
        // Raycast from the near point to the far point to find any rigid bodies intersected
        let results = physicsWorld.rayCast(from: rayStart, to: rayEnd)
        
        // Apply an impulse to any rigid bodies we've touched, along the z axis
        for result in results {
            guard let rigidBody = result.rigidBody else { continue }
            guard rigidBody.type == .dynamic else { continue }
            rigidBody.applyForce(.vector(0, 0, 200), impulse: true)
        }
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
        
        spawnRigidBodies()
        
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
