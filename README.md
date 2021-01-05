<img src="https://user-images.githubusercontent.com/2840242/84842193-7fe78280-b012-11ea-98f7-a71c29a68174.png" width=256></img>

An open source iOS / macOS wrapper for the Bullet physics library, with additional support for SceneKit.

## Requirements

PhysicsKit is packaged as a universal XCFramework, built for iOS and macOS, distributed via Swift Package Manager or Cocoapods.

## Installation Via Cocoapods

Reference PhysicsKit in your podfile:

```ruby
pod 'PhysicsKit'
```

Run pod install or pod update. Then, import it into your Swift source and begin using the framework:

```swift
import PhysicsKit
```

## Installation Via Swift Package Manager

1. In Xcode, select File > Swift Packages > Add Package Dependency
2. Enter "https://github.com/AdamEisfeld/PhysicsKit" for the remote url, and click Next
3. Enter the desired version number (2.0 an onwards supported) or branch and click Next
4. Click Finish

Then, import it into your Swift source and begin using the framework:

```swift
import PhysicsKit
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
physicsWorld.add(dynamicBody)

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
physicsWorld.add(staticBody)
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
physicsWorld.add(trigger)
```

## Connecting PhysicsKit to SceneKit

We need a way to visualize the physics simulation. You could use a renderer of your choice (eg a custom OpenGL or Metal renderer), or use SceneKit to handle the heavy lifting.

The PhysicsScene class provides a mechanism for wiring a PKRigidBody to a SCNNode, such that the node's position / orientation updates as the associated PKRigidBody is moved around in the simulation.

### Create a PhysicsScene

```swift
let physicsScene = PKPhysicsScene(isMotionStateEnabled: true)
```

### Add / Attach PKRigidBodies and SCNNodes

```swift

let node: SCNNode = ...
let rigidBody: PKRigidBody = ...
let physicsWorld: PKPhysicsWorld = ...
let scene: SCNScene = ...

scene.rootNode.addChildNode(node)
physicsWorld.add(rigidBody)
physicsScene.attach(rigidBody, to: node)

```

### Motion States or Manual Updates

In order to orient the SCNNodes to their attached PKRigidBody instances, PKPhysicsScene has 2 options, based on the isMotionStateEnabled value passed to it's initializer:

- isMotionStateEnabled = true: The physics scene will automatically listen to the Bullet physics engine for any transform changes on a given rigid body, and apply those to the associated scenekit node.
- isMotionStateEnabled = false: You must manually force the physics scene to update it's scenekit node transforms, via calling iterativelyOrientAllNodesToAttachedRigidBodies() on the physics scene.

### Actions

As of PhysicsKit 1.0.2, PKActions have been added. Similar to SCNActions in SceneKit, you can construct PKActions to modify a rigid body's attributes over time for things like animations.

You can create a custom PKAction, or use one of the provided helper constructors, eg:

```swift
// Move the rigid body to a new position in 1 second
let moveActionTo = PKAction.move(rigidBody, to: someNewPosition, duration: 1.0)
moveActionTo.run()

// Move the rigid body forwards by 1 unit / second, constantly
let moveActionBy = PKAction.move(rigidBody, by: .vector(0, 0, 1), duration: 1.0)
moveActionBy.repeatCount = -1 // Repeat forever
moveActionBy.run()

// Rotate the rigid body around it's y axis 180 degrees / second, 3 times
let orientAction = PKAction.orient(rigidBody, by: .euler(0, 180, 0, .degrees), duration: 1.0)
orientAction.repeatCount = 3
orientAction.run()
```

Note that only kinematic rigid bodies support PKActions. Adding PKActions to static/dynamic rigid bodies may have undefined behavior.

### Raycasting

As of PhysicsKit 1.0.3, raycasting has been added. Perform raycasts via the PKPhysicsWorld to determine which rigid bodies intersect a ray:

```swift
let start: PKVector3 = .vector(0, 10, 0)
let end: PKVector3 = .vector(0, -10, 0)
let results = physicsWorld.rayCast(from: start, to: end)
for result in results {
   let intersectedRigidBody = result.rigidBody
   let intersectionWorldPosition = result.worldPosition
   let intersectionWorldNormal = result.worldNormal
}
```

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

## Updating Bullet

PhysicsKit currently targets Bullet v2.89

### To install Bullet locally:

1. Ensure cmake is installed
> * Install cmake via https://cmake.org/download/
> * Install cmake command-line tools via PATH="/Applications/CMake.app/Contents/bin":"$PATH"

2. Install desired Bullet library
> * Install Bullet from https://github.com/bulletphysics/bullet3
> * Run xcode.command from bullet folder to generate Xcode projects

### To modify which Bullet source files PhysicsKit targets:

1. Find the folder within bullet that contains your desired source. For example, "src/LinearMath"
2. Copy this folder into the repo, at PhysicsKit-shared/bullet
3. Drag this folder into the PhysicsKit Xcode project, under the "bullet" group
4. Ensure "Create groups" is selected, do not select any targets, and click Finish
5. Search for any .cpp files in the added directory, and manually add them to the PhysicsKit-ios and PhysicsKit-macos targets
6. Add "-w" compiler flag to all cpp files, via Target / Build Phases / Compile Sources

## Updating PhysicsKit

After making any desired changes, follow these steps to release a new version of PhysicsKit:

1. In terminal, navigate to the root directory of PhysicsKit, and run the helper script buildPhysicsKit.sh. This script will:
> * Create .xcarchives of PhysicsKit for all of the supported platforms
> * Bundle these xcarchives together into an xcframework

2. Still in terminal, run the helper script deployPhysicsKit.sh, passing the version number you'd like to apply for the given release. PhysicsKit uses Semantic Versioning (see https://semver.org). This script will:
> * Update the version declared in the podspec
> * Tag the current git branch with the version number
> * Run "pod lib lint" to ensure Cocoapods functionality is not broken.
> * Stage all changes for commit
> * Commit all changes (a commit message dialog will appear)
> * Push the branch and version tag to the remote repo
> * Push the pod up to CocoaPods for public consumption

## Adding Objc Files

1. Add any desired Objc files under the "objc" folder
2. Ensure implementation files support objc++ by replacing ".m" extension with ".mm"
3. Add any c++ dependencies to a separate "MyClassName+Internal.h" file which extends your class
4. Add imports to PhysicsKit.h file. "MyClassName+Internal.h" files should not be imported here / exposed to Swift

## Adding Platform-Specific Files

1. Add any iOS-specific files to the PhysicsKit-ios directory / link them to the PhysicsKit-ios target
2. Add any macOS-specific files to the PhysicsKit-macos directory / link them to the PhysicsKit-macos target

## Author

Adam Eisfeld, adam.eisfeld@gmail.com

## License

PhysicsKit is available under the zlib license. See the LICENSE file for more info.
