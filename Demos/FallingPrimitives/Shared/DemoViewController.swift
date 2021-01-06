//
//  DemoViewController.swift
//  FallingPrimitives
//
//  Created by Adam Eisfeld on 2021-01-05.
//

import Foundation
import PhyKit

/// This view controller displays an SCNView wired up to PhyKit
public class DemoViewController: BridgeViewController {
    
    // MARK: Typealiases
    
    typealias SpawnedNode = (rigidBody: PHYRigidBody, displayNode: SCNNode)
    
    // MARK: Properties
    
    private let sceneView = SCNView()
    private var sceneTime: TimeInterval?
    private let physicsWorld = PHYWorld()
    private lazy var physicsScene = PHYScene(isMotionStateEnabled: false)
    private var spawnedNodes: [String : SpawnedNode] = [:]
    private var lastSpawnTime: Date = Date()
    
    // MARK: Setup
    
    public override func loadView() {
        self.view = BridgeView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Embed an SCNView in our VC's view, loading a basic scene
        setupSceneView(sceneName: "world")
        
        // Setup our physics world
        setupWorld()
        
        // Create a static ground object for our objects to bounce off of
        createGroundPedastle(position: .vector(0, -5, 0), orientation: .identity)
        
        // Create a kinematic logo object that we'll move around to interact with the scene
        createLogo()
        
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
    
    private func spawnRandomRigidBody() {
            
        let primitiveTypes: [String] = [
            "box", "sphere", "capsule", "cylinder"
        ]
        
        let primitiveTypeIndex = Int.random(in: 0..<primitiveTypes.count)
        let primitiveType = primitiveTypes[primitiveTypeIndex]
        
        let position: PHYVector3 = .vector(Float.random(in: -10..<10), Float.random(in: 50..<Float(100)), Float.random(in: -10..<10))
        let orientation: PHYQuaternion = .euler(Float.random(in: 0..<360), Float.random(in: 0..<360), Float.random(in: 0..<360), .degrees)
        
        let spawnedNode: SpawnedNode
        
        switch primitiveType {
        case "box":
            spawnedNode = createBox(width: Float.random(in: 1..<3), height: Float.random(in: 1..<3), length: Float.random(in: 1..<3), position: position, orientation: orientation, type: .dynamic)
        case "sphere":
            spawnedNode = createSphere(radius: Float.random(in: 1..<3), position: position, orientation: orientation, type: .dynamic)
        case "capsule":
            spawnedNode = createCapsule(radius: Float.random(in: 1..<1.5), height: Float.random(in: 5..<10), position: position, orientation: orientation, type: .dynamic)
        case "cylinder":
            spawnedNode = createCylinder(radius: Float.random(in: 1..<1.5), height: Float.random(in: 5..<10), position: position, orientation: orientation, type: .dynamic)
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
        
        let collisionScene = SCNScene(named: "Scenes.scnassets/phylogo.scn")!
        let collisionNode = collisionScene.rootNode.childNode(withName: "root", recursively: true)!
        
        let collisionShapes = collisionNode.generateCollisionShapes()

        let collisionShape = PHYCollisionShapeCompound(collisionShapes: collisionShapes)
        
        let scene = SCNScene(named: "Scenes.scnassets/phylogo.scn")!
        let displayNode = scene.rootNode.childNode(withName: "root", recursively: true)!
        
        let rigidBody = PHYRigidBody(type: .kinematic, shape: collisionShape)

        rigidBody.restitution = 0.8
        rigidBody.isSleepingEnabled = false
        rigidBody.position = .vector(0, -1, 0)
        
        // Create an action that moves the logo up/down via a sinewave
        var inc: Float = 0
        let moveAction = PHYAction.move(rigidBody, byFunction: { () -> (PHYVector3) in
            let y = sin(inc)
            inc += 0.02
            return .vector(0, y * 0.1, 0)
        })
        moveAction.repeatCount = -1
        
        // Create an action that rotates the logo constantly around it's y axis
        let orientAction = PHYAction.orient(rigidBody, by: .euler(0, 180, 0, .degrees), duration: 2.0)
        orientAction.repeatCount = -1
        
        // Run the actions
        moveAction.run()
        orientAction.run()

        physicsWorld.add(rigidBody)
        sceneView.scene!.rootNode.addChildNode(displayNode)
        physicsScene.attach(rigidBody, to: displayNode)
        
    }
    
    private func createGroundPedastle(position: PHYVector3, orientation: PHYQuaternion) {
        // Create a box
        let geometry = SCNCylinder(radius: 14, height: 2)
        let displayNode = SCNNode(geometry: geometry)
        
        // Color the geometry
        let material = SCNMaterial()
        material.diffuse.contents = BridgeColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        material.lightingModel = .physicallyBased
        geometry.materials = [material]
        
        // Create a physics body for the box
        let collisionShape = PHYCollisionShapeCylinder(radius: 14, height: 2)
        let rigidBody = PHYRigidBody(type: .static, shape: collisionShape)
        
        rigidBody.position = position
        rigidBody.orientation = orientation
        rigidBody.isSleepingEnabled = false
        
        physicsWorld.add(rigidBody)
        sceneView.scene!.rootNode.addChildNode(displayNode)
        physicsScene.attach(rigidBody, to: displayNode)
    }
    
    private func createGroundPlane(position: PHYVector3, orientation: PHYQuaternion) {
        
        // Create a box
        let geometry = SCNFloor()
        let displayNode = SCNNode(geometry: geometry)
        
        // Color the geometry
        let material = SCNMaterial()
        material.diffuse.contents = BridgeColor.white
        material.lightingModel = .physicallyBased
        geometry.materials = [material]
        
        // Create a physics body for the box
        let collisionShape = PHYCollisionShapeStaticPlane()
        let rigidBody = PHYRigidBody(type: .static, shape: collisionShape)
        
        rigidBody.position = position
        rigidBody.orientation = orientation
        rigidBody.isSleepingEnabled = false
        
        physicsWorld.add(rigidBody)
        sceneView.scene!.rootNode.addChildNode(displayNode)
        physicsScene.attach(rigidBody, to: displayNode)
        
    }
    
    private func createBox(width: Float, height: Float, length: Float, position: PHYVector3, orientation: PHYQuaternion, type: PHYRigidBodyType) -> SpawnedNode  {
        
        // Create a box
        let geometry = SCNBox(width: CGFloat(width), height: CGFloat(height), length: CGFloat(length), chamferRadius: 0.0)
        let displayNode = SCNNode(geometry: geometry)
        
        // Color the geometry
        let material = SCNMaterial()
        material.diffuse.contents = BridgeColor(red: 235.0/255.0, green: 64.0/255.0, blue: 52.0/255.0, alpha: 1.0)
        material.lightingModel = .physicallyBased
        geometry.materials = [material]
        
        // Create a physics body for the box
        let collisionShape = PHYCollisionShapeBox(width: width, height: height, length: length)
        
        let rigidBody = PHYRigidBody(type: type, shape: collisionShape)
        rigidBody.position = position
        rigidBody.orientation = orientation
        rigidBody.restitution = 0.8
        rigidBody.isSleepingEnabled = false
        
        physicsWorld.add(rigidBody)
        sceneView.scene!.rootNode.addChildNode(displayNode)
        physicsScene.attach(rigidBody, to: displayNode)
        
        return SpawnedNode(rigidBody, displayNode)
        
    }
    
    private func createSphere(radius: Float, position: PHYVector3, orientation: PHYQuaternion, type: PHYRigidBodyType) -> SpawnedNode  {
        
        // Create a sphere
        let geometry = SCNSphere(radius: CGFloat(radius))
        let displayNode = SCNNode(geometry: geometry)
        
        // Color the geometry
        let material = SCNMaterial()
        material.diffuse.contents = BridgeColor(red: 52.0/255.0, green: 174.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        material.lightingModel = .physicallyBased
        geometry.materials = [material]
        
        // Create a physics body for the sphere
        let collisionShape = PHYCollisionShapeSphere(radius: radius)
        let rigidBody = PHYRigidBody(type: type, shape: collisionShape)
        
        rigidBody.position = position
        rigidBody.orientation = orientation
        rigidBody.restitution = 0.8
        rigidBody.isSleepingEnabled = false
        
        physicsWorld.add(rigidBody)
        sceneView.scene!.rootNode.addChildNode(displayNode)
        physicsScene.attach(rigidBody, to: displayNode)
        
        return SpawnedNode(rigidBody, displayNode)
        
    }
    
    private func createCapsule(radius: Float, height: Float, position: PHYVector3, orientation: PHYQuaternion, type: PHYRigidBodyType) -> SpawnedNode  {
        
        // Create a sphere
        let geometry = SCNCapsule(capRadius: CGFloat(radius), height: CGFloat(height))
        let displayNode = SCNNode(geometry: geometry)
        
        // Color the geometry
        let material = SCNMaterial()
        material.diffuse.contents = BridgeColor(red: 201.0/255.0, green: 52.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        material.lightingModel = .physicallyBased
        geometry.materials = [material]
        
        // Create a physics body for the sphere
        let collisionShape = PHYCollisionShapeCapsule(radius: radius, height: height)
        let rigidBody = PHYRigidBody(type: type, shape: collisionShape)
        
        rigidBody.position = position
        rigidBody.orientation = orientation
        rigidBody.restitution = 0.8
        rigidBody.isSleepingEnabled = false
        
        physicsWorld.add(rigidBody)
        sceneView.scene!.rootNode.addChildNode(displayNode)
        physicsScene.attach(rigidBody, to: displayNode)
        
        return SpawnedNode(rigidBody, displayNode)
        
    }
    
    private func createCylinder(radius: Float, height: Float, position: PHYVector3, orientation: PHYQuaternion, type: PHYRigidBodyType) -> SpawnedNode  {
        
        // Create a sphere
        let geometry = SCNCylinder(radius: CGFloat(radius), height: CGFloat(height))
        let displayNode = SCNNode(geometry: geometry)
        
        // Color the geometry
        let material = SCNMaterial()
        material.diffuse.contents = BridgeColor(red: 186.0/255.0, green: 235.0/255.0, blue: 52.0/255.0, alpha: 1.0)
        material.lightingModel = .physicallyBased
        geometry.materials = [material]
        
        // Create a physics body for the sphere
        let collisionShape = PHYCollisionShapeCylinder(radius: radius, height: height)
        let rigidBody = PHYRigidBody(type: type, shape: collisionShape)
        
        rigidBody.position = position
        rigidBody.orientation = orientation
        rigidBody.restitution = 0.8
        rigidBody.isSleepingEnabled = false
        
        physicsWorld.add(rigidBody)
        sceneView.scene!.rootNode.addChildNode(displayNode)
        physicsScene.attach(rigidBody, to: displayNode)
        
        return SpawnedNode(rigidBody, displayNode)
        
    }
    
}

extension DemoViewController: PHYWorldSimulationDelegate {
    
    public func physicsWorld(_ physicsWorld: PHYWorld, willSimulateAtTime time: TimeInterval) {
        
    }
    
    public func physicsWorld(_ physicsWorld: PHYWorld, didSimulateAtTime time: TimeInterval) {
        
    }
    
}

extension DemoViewController: PHYWorldCollisionDelegate {
    
    public func physicsWorld(_ physicsWorld: PHYWorld, collisionDidBeginAtTime time: TimeInterval, with collisionPair: PHYCollisionPair) {

    }
    
    public func physicsWorld(_ physicsWorld: PHYWorld, collisionDidContinueAtTime time: TimeInterval, with collisionPair: PHYCollisionPair) {

    }
    
    public func physicsWorld(_ physicsWorld: PHYWorld, collisionDidEndAtTime time: TimeInterval, with collisionPair: PHYCollisionPair) {
        
    }
    
}

extension DemoViewController: PHYWorldTriggerDelegate {
    
    public func physicsWorld(_ physicsWorld: PHYWorld, triggerDidBeginAtTime time: TimeInterval, with collisionPair: PHYTriggerPair) {

    }
    
    public func physicsWorld(_ physicsWorld: PHYWorld, triggerDidContinueAtTime time: TimeInterval, with collisionPair: PHYTriggerPair) {

    }
    
    public func physicsWorld(_ physicsWorld: PHYWorld, triggerDidEndAtTime time: TimeInterval, with collisionPair: PHYTriggerPair) {

    }
    
}

extension DemoViewController: SCNSceneRendererDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        spawnRigidBodies()
        
        sceneTime = sceneTime ?? time
        let physicsTime = time - sceneTime!
        
        physicsWorld.simulationTime = physicsTime
        physicsScene.iterativelyOrientAllNodesToAttachedRigidBodies()
        
    }
    
}

extension DemoViewController: PHYSceneUpdateDelegate {
    
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

// Helper code for generating a collision shape from a node

extension SCNNode {
    
    func generateCollisionShapes() -> [PHYCollisionShape] {
        
        var shapes: [PHYCollisionShape] = []
        
        if let geometry = geometry {
            let physicsGeometry = PHYGeometry(scnGeometry: geometry)
            let collisionShape = PHYCollisionShapeGeometry(geometry: physicsGeometry, type: .convex, transform: worldTransform.blMatrix)
            shapes.append(collisionShape)
        }
        
        for childNode in childNodes {
            shapes.append(contentsOf: childNode.generateCollisionShapes())
        }
        
        return shapes
        
    }
    
}
