<img src="https://user-images.githubusercontent.com/2840242/103815453-6307b080-5031-11eb-81f5-2be0467fa950.png" width=256></img>

An open source iOS / macOS wrapper for the Bullet physics library, with additional support for SceneKit.

<img src="https://user-images.githubusercontent.com/2840242/103972814-ce3da980-513b-11eb-8f7a-cc102e3a3078.gif"></img>

## Requirements

PhyKit is packaged as a universal XCFramework, built for iOS and macOS, distributed via Swift Package Manager or Cocoapods.

## Installation Via Swift Package Manager

1. In Xcode, select File > Swift Packages > Add Package Dependency
2. Enter "https://github.com/AdamEisfeld/PhyKit" for the remote url, and click Next
3. Enter the desired version number and click Next
4. Click Finish

Then, import it into your Swift source and begin using the framework:

```swift
import PhyKit
```

## Installation Via Cocoapods

Reference PhyKit in your podfile ("PhyKit" was taken on CocoaPods, so the pod name is PhyKitCocoapod):

```ruby
pod 'PhyKitCocoapod'
```

Run pod install or pod update. Then, import it into your Swift source and begin using the framework:

```swift
import PhyKit
```

## Example Usage

### Create a Physics World to run your simulation

A PHYWorld handles running the Bullet physics simulation on a series of attached PHYRigidBody instances

```swift
let physicsWorld = PHYWorld()
```

### Create a Dynamic Rigid Body to add to the Physics World

Dynamic Rigid Bodies are affected by forces / collisions.

```swift

// Create a collision shape to describe the rigid body
let dynamicCollisionShape = PHYCollisionShapeBox(size: 1.0)

// Create a rigid body from this physics shape, with a type of "dynamic" so forces / collisions affect it
let dynamicBody = PHYRigidBody(type: .dynamic, shape: dynamicCollisionShape)

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
PhyKit also supports Kinematic Rigid Bodies, not shown here.

```swift

// Create a collision shape to describe the rigid body
let staticCollisionShape = PHYCollisionShapeBox(width: 100, height: 0.01, length: 100)

// Create a rigid body from this physics shape, with a type of "static" so forces / collisions don't affect it. Other dynamic bodies can still collide with this body.
let staticBody = PHYRigidBody(type: .static, shape: staticCollisionShape)

// Add the rigid body to the physics world
physicsWorld.add(staticBody)
```

### Step the Physics Simulation

To run the simulation, you must "step" the physics simulation forward by some delta time. Typically, this time would be equal to the elapsed time since the
last time you stepped the simulation.

You might use a CADisplayLink (PHYDisplayLink uses CADisplayLink on iOS and CVDisplayLink on macOS), or SceneKit's SCNView's render loop to perform this call.

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

Sometimes it is useful to detect when a given rigid body enters an area within the physics simulation. PHYTriggers provide this functionality:

```swift
let triggerShape = PHYCollisionShapeSphere(radius: 1.0)
let trigger = PHYTrigger(shape: triggerShape)
physicsWorld.add(trigger)
```

## Connecting PhyKit to SceneKit

We need a way to visualize the physics simulation. You could use a renderer of your choice (eg a custom OpenGL or Metal renderer), or use SceneKit to handle the heavy lifting.

The PHYScene class provides a mechanism for wiring a PHYRigidBody to a SCNNode, such that the node's position / orientation updates as the associated PHYRigidBody is moved around in the simulation.

### Create a Physics Scene

```swift
let physicsScene = PHYScene(isMotionStateEnabled: true)
```

### Add / Attach PHYRigidBodies and SCNNodes

```swift

let node: SCNNode = ...
let rigidBody: PHYRigidBody = ...
let physicsWorld: PHYWorld = ...
let scene: SCNScene = ...

scene.rootNode.addChildNode(node)
physicsWorld.add(rigidBody)
physicsScene.attach(rigidBody, to: node)

```

### Motion States or Manual Updates

In order to orient the SCNNodes to their attached PHYRigidBody instances, PHYScene has 2 options, based on the isMotionStateEnabled value passed to it's initializer:

- isMotionStateEnabled = true: The physics scene will automatically listen to the Bullet physics engine for any transform changes on a given rigid body, and apply those to the associated scenekit node.
- isMotionStateEnabled = false: You must manually force the physics scene to update it's scenekit node transforms, via calling iterativelyOrientAllNodesToAttachedRigidBodies() on the physics scene.

### Actions

As of PhyKit 1.0.2, PHYActions have been added. Similar to SCNActions in SceneKit, you can construct PHYActions to modify a rigid body's attributes over time for things like animations.

You can create a custom PHYAction, or use one of the provided helper constructors, eg:

```swift
// Move the rigid body to a new position in 1 second
let moveActionTo = PHYAction.move(rigidBody, to: someNewPosition, duration: 1.0)
moveActionTo.run()

// Move the rigid body forwards by 1 unit / second, constantly
let moveActionBy = PHYAction.move(rigidBody, by: .vector(0, 0, 1), duration: 1.0)
moveActionBy.repeatCount = -1 // Repeat forever
moveActionBy.run()

// Rotate the rigid body around it's y axis 180 degrees / second, 3 times
let orientAction = PHYAction.orient(rigidBody, by: .euler(0, 180, 0, .degrees), duration: 1.0)
orientAction.repeatCount = 3
orientAction.run()
```

Note that only kinematic rigid bodies support PHYActions. Adding PHYActions to static/dynamic rigid bodies may have undefined behavior.

### Raycasting

As of PhyKit 1.0.3, raycasting has been added. Perform raycasts via the PHYWorld to determine which rigid bodies intersect a ray:

```swift
let start: PHYVector3 = .vector(0, 10, 0)
let end: PHYVector3 = .vector(0, -10, 0)
let results = physicsWorld.rayCast(from: start, to: end)
for result in results {
   let intersectedRigidBody = result.rigidBody
   let intersectionWorldPosition = result.worldPosition
   let intersectionWorldNormal = result.worldNormal
}
```

## Delegates

### Observing Simulation Changes

Become the simulationDelegate of a PHYWorld by conforming to the PHYWorldSimulationDelegate protocol. This delegate will be notified before and after the simulation is stepped forward.

### Observing Collisions

Become the collisionDelegate of a PHYWorld by conforming to the PHYWorldCollisionDelegate protocol. This delegate will be notified as collisions begin, continue, and end between any 2 rigid bodies.

### Observing Trigger Zones

Become the triggerDelegate of a PHYWorld by conforming to the PHYWorldTriggerDelegate protocol. This delegate will be notified as rigid bodies enter, remain in, and exit trigger zones.

### Observing Physics Scene Updates

Become the delegate of a PHYScene by conforming to the PHYSceneUpdateDelegate protocol. This delegate will be notified before and after nodes are oriented to their rigid bodies, and will also be notified when a given rigid body's internal transform changes if the physics scene's isMotionStateEnabled is set to true.

## Collision Shapes

Collision Shapes are a fundamental building block of a physics simulation. PhyKit comes with many options for constructing physics shapes to get the correct behavior, including:

- PHYCollisionShapeBox
- PHYCollisionShapeSphere
- PHYCollisionShapeCapsule
- PHYCollisionShapeGeometry (allows you to construct a physics shape from an existing SceneKit SCNGeometry instance, which can be loaded from an external Collada .dae file, SceneKit .scn file, or built from a series of SCNGeometry instances)
- PHYCollisionShapeStaticPlane (an infinite plane, useful for grounds / walls)
- PHYCollisionShapeFromData (allows you to construct a physics shape from previously serialized collision shape data)
- PHYCollisionShapeCompound (allows you to construct a physics shape from an array of other PHYCollisionShapes)

PHYCollisionShapeFromData is useful for speeding up simulation setup. It can take some time to generate collision meshs, especially when loaded from non-standard primitive shapes (eg PHYCollisionShapeGeometry).
All PHYCollisionShapes have a serialize() function that lets you obtain a Data representation of them, which can be saved to disk / packaged with your application bundle. You can then use PHYCollisionShapeFromData to load these shapes.

```swift

let originalCollisionShape = PHYCollisionShapeGeometry(...)
let data = originalCollisionShape.serialize() // Save this data to disk somewhere, and stop using PHYCollisionShapeGeometry in favor of:
let recreatedCollisionShape = PHYCollisionShapeFromData(data)

```

## Updating Bullet

PhyKit currently targets Bullet v2.89

### To install Bullet locally:

1. Ensure cmake is installed
> * Install cmake via https://cmake.org/download/
> * Install cmake command-line tools via PATH="/Applications/CMake.app/Contents/bin":"$PATH"

2. Install desired Bullet library
> * Install Bullet from https://github.com/bulletphysics/bullet3
> * Run xcode.command from bullet folder to generate Xcode projects

### To modify which Bullet source files PhyKit targets:

1. Find the folder within bullet that contains your desired source. For example, "src/LinearMath"
2. Copy this folder into the repo, at PhyKit-shared/bullet
3. Drag this folder into the PhyKit Xcode project, under the "bullet" group
4. Ensure "Create groups" is selected, do not select any targets, and click Finish
5. Search for any .cpp files in the added directory, and manually add them to the PhyKit-ios and PhyKit-macos targets
6. Add "-w" compiler flag to all cpp files, via Target / Build Phases / Compile Sources

## Updating PhyKit

After making any desired changes, follow these steps to release a new version of PhyKit:

1. In terminal, navigate to the root directory of PhyKit, and run the helper script ```./buildPhy.sh```. This script will:
> * Create .xcarchives of PhyKit for all of the supported platforms
> * Bundle these xcarchives together into an xcframework

2. Still in terminal, run the helper deployPhy script, passing the version number you'd like to apply for the given release (eg  ```./deployPhy.sh 1.2.3```). PhyKit uses Semantic Versioning (see https://semver.org). This script will:
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
4. Add imports to PhyKit.h file. "MyClassName+Internal.h" files should not be imported here / exposed to Swift

## Adding Platform-Specific Files

1. Add any iOS-specific files to the PhyKit-ios directory / link them to the PhyKit-ios target
2. Add any macOS-specific files to the PhyKit-macos directory / link them to the PhyKit-macos target

## Development

Open the included "Scratchpad" Xcode project to work on PHYKit's source wired to a boilerplate cross-platform application with a basic scene setup.

## Author

Adam Eisfeld, adam.eisfeld@gmail.com

## License

PhyKit is available under the zlib license. See the LICENSE file for more info.
