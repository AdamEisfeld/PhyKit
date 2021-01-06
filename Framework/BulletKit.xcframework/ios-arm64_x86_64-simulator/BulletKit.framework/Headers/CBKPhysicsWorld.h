//
//  CBKPhysicsWorld.h
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-10.
//  Copyright © 2020 adam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@class CBKRigidBody;
@class CBKPhysicsTrigger;
struct BKVector3;

NS_ASSUME_NONNULL_BEGIN

@interface CBKPhysicsWorld : NSObject

@property (nonatomic, assign) struct BKVector3 gravity;

- (void)internalAddRigidBody: (CBKRigidBody *)rigidBody;
- (void)internalRemoveRigidBody: (CBKRigidBody *)rigidBody;

- (void)internalAddPhysicsTrigger: (CBKPhysicsTrigger *)physicsTrigger;
- (void)internalRemovePhysicsTrigger: (CBKPhysicsTrigger *)physicsTrigger;

- (void)internalStepSimulation: (NSTimeInterval)time;
- (void)internalCheckCollisions;
- (void)internalCollisionDidOccur: (CBKRigidBody *)internalRigidBodyA localPositionA: (struct BKVector3 )pointA internalRigidBodyB: (CBKRigidBody *)internalRigidBodyB localPositionB: (struct BKVector3 )pointB;
- (void)internalRaycastAllFrom: (struct BKVector3 )from to: (struct BKVector3 )to perform: (void (^_Nullable)(struct BKVector3 position, struct BKVector3 normal, CBKRigidBody* rigidBody))hitResult;
- (void)internalReset;

@end

NS_ASSUME_NONNULL_END

/**

Bullet Install Process:
(Followed info here: https://www.raywenderlich.com/2606-bullet-physics-tutorial-getting-started)

1. Downloaded bullet 2.89 from https://github.com/bulletphysics/bullet3
2. Downloaded cmake 3.18.0 from https://cmake.org/download/
3. Installed cmake to terminal via PATH="/Applications/CMake.app/Contents/bin":"$PATH"
4. Open xcode.command from bullet folder (right click, Open), which builds bullet and opens a demo xcode workspace
5. Close workspace
6. Rename to bulletLib, and Copy the entire bullet folder (the entire download, which now includes the xcode4 subdir) into your xcode
workspace / project's root directory (don't drag it into xcode, just use finder, we just need these files to live
in the same directory, we won't link against all of them)
7. Drag BulletCollision.xcodeproj, BulletDynamics.xcodeproj and LinearMath.xcodeproj from the xcode4 folder into
your xcode project, at the top level (just under the main project file)

8. Click the main project's target, to add search paths:
   - Find "Search Paths/User Header Search Paths" in the target
   - Add an entry to target the /src file. Should be $(SRCROOT)/bulletLib/src

9. In your project's Target Dependencies (under build phases), add the 3 libraries
10. In the Link Binary With Libraries section further down, again add the 3 libraries
11. In each Bullet project, go into the Target build settings and change "Base SDK" to "iOS"
12. Finally, allow Xcode to update the projects to recommended settings


*/
