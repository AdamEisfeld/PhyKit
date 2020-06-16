# PhysicsKit

An open source wrapper for the Bullet physics library, with additional support for mapping physics bodies to SceneKit nodes in favor of SceneKit's stock physics engine.

## Requirements

PhysicsKit is currently built for iOS. Additional work is required to provide a MacOS port.

## Installation

PhysicsKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PhysicsKit'
```

## Example Usage

### Create a Physics World to run your simulation

A PKPhysicsWorld handles running the Bullet physics simulation on a series of attached PKRigidBody instances

```swift
let physicsWorld = PKPhysicsWorld()
```

### Create a Dynamic Rigid Body to add to the Physics World

Dynamic Rigid Bodies are affected by forces / collisions.

```swift

// Create a collision shape to describe the rigid body
let dynamicCollisionShape = PKCollisionShapeBox(size: 1.0)

// Create a rigid body from this physics shape, with a type of "dynamic" so forces / collisions affect it
let dynamicBody = PKRigidBody(type: .dynamic, shape: dynamicCollisionShape)

// Customize the rigid body's physical properties
dynamicBody.restitution = 0.8

// Add the rigid body to the physics world
physicsWorld.add(dynamicBody, for: "box")

```

### Configure the Rigid Body's transform

There are several ways for modifying a Rigid Body's position / rotation. A few are shown below.

```swift

// Position the rigid body 10 units above the "ground"
dynamicBody.position = .vector(0, 10, 0)

// You can adjust a rigid body's rotation either via quaternions...
dynamicBody.orientation = .quaternion(0,0,0,1)

// ...or via euler angles (in either radians or degrees)
dynamicBody.orientation = .euler(0, 0, 45, .degrees)
```

### Create a Static Rigid Body to add to the Physics World

Static Rigid Bodies are not affected by forces / collisions, but other Dynamic Rigid Bodies can collide with them.
PhysicsKit also supports Kinematic Rigid Bodies, not shown here.

```swift

// Create a collision shape to describe the rigid body
let staticCollisionShape = PKCollisionShapeBox(width: 100, height: 0.01, length: 100)

// Create a rigid body from this physics shape, with a type of "static" so forces / collisions don't affect it. Other dynamic bodies can still collide with this body.
let staticBody = PKRigidBody(type: .static, shape: staticCollisionShape)

// Add the rigid body to the physics world
physicsWorld.add(staticBody, for: "ground")
```

### Step the Physics Simulation

To run the simulation, you must "step" the physics simulation forward by some delta time. Typically, this time would be equal to the elapsed time since the
last time you stepped the simulation.

You might use a CADisplayLink, or SceneKit's SCNView's render loop to perform this call.

```swift

class SomeViewController: UIViewController {

    var sceneTime: TimeInterval? = nil
    
    ... setup an SCNView, and wire this view controller up to the view's delegate property

}
extension SomeViewController: SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        // Determine how much time has elapsed since we last stepped the simulation
        sceneTime = sceneTime ?? time
        let physicsTime = time - sceneTime!
        
        // Step the simulation
        physicsWorld.simulationTime = physicsTime
        
    }
    
}
```

### Add Trigger Zones

Sometimes it is useful to detect when a given rigid body enters an area within the physics simulation. PKTriggers provide this functionality:

```swift
let triggerShape = PKCollisionShapeSphere(radius: 1.0)
let trigger = PKTrigger(shape: triggerShape)
physicsWorld.add(trigger, for: "someZone")
```

## Connecting PhysicsKit to SceneKit

We need a way to visualize the physics simulation. You could use a renderer of your choice (eg a custom OpenGL or Metal renderer), or use SceneKit to handle the heavy lifting.

The PhysicsScene class provides a mechanism for wiring a PKRigidBody to a SCNNode, such that the node's position / orientation updates as the associated PKRigidBody is moved around in the simulation.

### Create a PhysicsScene

```swift
let physicsWorld: PKPhysicsWorld = ...
let scene: SCNScene = ...
let physicsScene = PKPhysicsScene(scene: scene, physicsWorld: physicsWorld, isMotionStateEnabled: true)
```

### Add / Attach PKRigidBodies and SCNNodes

```swift

let node: SCNNode = ...
let rigidBody: PKRigidBody = ...

physicsScene.add(node)
physicsScene.add(rigidBody)
physicsScene.attach(rigidBody, to: node)

```

### Motion States or Manual Updates

In order to orient the SCNNodes to their attached PKRigidBody instances, PKPhysicsScene has 2 options, based on the isMotionStateEnabled value passed to it's initializer:

- isMotionStateEnabled = true: The physics scene will automatically listen to the Bullet physics engine for any transform changes on a given rigid body, and apply those to the associated scenekit node.
- isMotionStateEnabled = false: You must manually force the physics scene to update it's scenekit node transforms, via calling iterativelyOrientAllNodesToAttachedRigidBodies() on the physics scene.

## Delegates

### Observing Simulation Changes

Become the simulationDelegate of a PKPhysicsWorld by conforming to the PKPhysicsWorldSimulationDelegate protocol. This delegate will be notified before and after the simulation is stepped forward.

### Observing Collisions

Become the collisionDelegate of a PKPhysicsWorld by conforming to the PKPhysicsWorldCollisionDelegate protocol. This delegate will be notified as collisions begin, continue, and end between any 2 rigid bodies.

### Observing Trigger Zones

Become the triggerDelegate of a PKPhysicsWorld by conforming to the PKPhysicsWorldTriggerDelegate protocol. This delegate will be notified as rigid bodies enter, remain in, and exit trigger zones.

### Observing Physics Scene Updates

Become the delegate of a PKPhysicsScene by conforming to the PKPhysicsSceneUpdateDelegate protocol. This delegate will be notified before and after nodes are oriented to their rigid bodies, and will also be notified when a given rigid body's internal transform changes if the physics scene's isMotionStateEnabled is set to true.

## Collision Shapes

Collision Shapes are a fundamental building block of a physics simulation. PhysicsKit comes with many options for constructing physics shapes to get the correct behavior, including:

- PKCollisionShapeBox
- PKCollisionShapeSphere
- PKCollisionShapeCapsule
- PKCollisionShapeGeometry (allows you to construct a physics shape from an existing SceneKit SCNGeometry instance, which can be loaded from an external Collada .dae file, SceneKit .scn file, or built from a series of SCNGeometry instances)
- PKCollisionShapeStaticPlane (an infinite plane, useful for grounds / walls)
- PKCollisionShapeFromData (allows you to construct a physics shape from previously serialized collision shape data)
- PKCollisionShapeCompound (allows you to construct a physics shape from an array of other PKCollisionShapes)

PKCollisionShapeFromData is useful for speeding up simulation setup. It can take some time to generate collision meshs, especially when loaded from non-standard primitive shapes (eg PKCollisionShapeGeometry). 
All PKCollisionShapes have a serialize() function that lets you obtain a Data representation of them, which can be saved to disk / packaged with your application bundle. You can then use PKCollisionShapeFromData to load these shapes.

```swift

let originalCollisionShape = PKCollisionShapeGeometry(...)
let data = originalCollisionShape.serialize() // Save this data to disk somewhere, and stop using PKCollisionShapeGeometry in favor of:
let recreatedCollisionShape = PKCollisionShapeFromData(data)

```


## Author

AdamEisfeld, adam.eisfeld@gmail.com

## License

PhysicsKit is available under the MIT license. See the LICENSE file for more info.
