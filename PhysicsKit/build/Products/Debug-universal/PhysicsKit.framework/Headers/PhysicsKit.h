//
//  PhysicsKit.h
//  PhysicsKit
//
//  Created by Adam Eisfeld on 2020-06-15.
//  Copyright © 2020 adameisfeld. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for PhysicsKit.
FOUNDATION_EXPORT double PhysicsKitVersionNumber;

//! Project version string for PhysicsKit.
FOUNDATION_EXPORT const unsigned char PhysicsKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <PhysicsKit/PublicHeader.h>

#import <PhysicsKit/PKBStructs.h>
#import <PhysicsKit/NSValue+PKBStructs.h>
#import <PhysicsKit/PKBPhysicsTrigger.h>
#import <PhysicsKit/PKBPhysicsWorld.h>
#import <PhysicsKit/PKBCollisionShape.h>
#import <PhysicsKit/PKBMesh.h>
#import <PhysicsKit/PKBGeometry.h>
#import <PhysicsKit/PKBVertex.h>
#import <PhysicsKit/PKBPolygon.h>
#import <PhysicsKit/PKBRigidBody.h>

/**
 
 Updating Bullet libraries:
 0a. Ensure cmake is installed:
    1. Install cmake application via https://cmake.org/download/
    2. Run terminal command: PATH="/Applications/CMake.app/Contents/bin":"$PATH"
 0b. Install bullet from https://github.com/bulletphysics/bullet3
 0c. Run xcode.command file from bullet folder to generate xcode projects
 
 1. Drag desired Bullet xcode projects from build3/xcode4 folder into PhysicsKit framework within Xcode, in PhysicsKit folder
 2. Connect in Dependencies / Link Binary With Libraries build phases of PhysicsKit target
 3. Configure PhysicsKit target's user header search paths to "$(SRCROOT)/PhysicsKit/bulletLib_2_89" , recursive set to true
 3b (optional) Let Xcode update connected projects to recommended settings
 4. Set "Inhibit All Warnings" to YES for each linked Bullet xcode project in target settings
 5. Set Valid Archtectures to $(ARCHS_STANDARD)
 5b. Add -fembed-bitcode to Other C Flags (might not be necessary)
 6. Build project, should be successful
 
 
 Exposing PBK / objc files to Swift:
 
 1. Add imports to this PhysicsKit.h file
 2. Ensure .h files target membership is set to "Public" for PhysicsKit target
 3. Any .h files that include c / c++ code should be marked "Private", and have "+Internal" in their name for record keeping
 */
