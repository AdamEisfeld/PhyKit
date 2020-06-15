//
//  PKPhysicsWorld.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-10.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation
import SceneKit


public class PKPhysicsWorld: PKBPhysicsWorld {
    
    public weak var simulationDelegate: PKPhysicsWorldSimulationDelegate?
    public weak var collisionDelegate: PKPhysicsWorldCollisionDelegate?
    public weak var triggerDelegate: PKPhysicsWorldTriggerDelegate?
    
    private var identifiersToRigidBodies: [String : PKRigidBody] = [:]
    private var rigidBodiesToIdentifiers: [PKRigidBody : String] = [:]
    
    private var identifiersToTriggers: [String : PKTrigger] = [:]
    private var triggersToIdentifiers: [PKTrigger : String] = [:]
    
    private var collisionPairs: [String : PKCollisionPair] = [:]
    private var previousCollisionPairs: [String : PKCollisionPair] = [:]
    
    private var triggerPairs: [String : PKTriggerPair] = [:]
    private var previousTriggerPairs: [String : PKTriggerPair] = [:]
    
    public var simulationTime: TimeInterval = 0 {
        didSet {
            stepSimulation(simulationTime)
        }
    }
    
    
    
    
    public func add(_ rigidBody: PKRigidBody, for identifier: String) {
        identifiersToRigidBodies[identifier] = rigidBody
        rigidBodiesToIdentifiers[rigidBody] = identifier
        internalAdd(rigidBody)
    }
    
    public func remove(_ rigidBody: PKRigidBody) {
        if let identifier = rigidBodiesToIdentifiers[rigidBody] {
            identifiersToRigidBodies[identifier] = nil
        }
        rigidBodiesToIdentifiers[rigidBody] = nil
        internalRemove(rigidBody)
    }
    
    public func getRigidBodyForIdentifier(_ identifier: String) -> PKRigidBody? {
        return identifiersToRigidBodies[identifier]
    }
    
    public func getIdentifierForRigidBody(_ rigidBody: PKRigidBody) -> String? {
        return rigidBodiesToIdentifiers[rigidBody]
    }
    
    
    
    
    
    public func add(_ trigger: PKTrigger, for identifier: String) {
        identifiersToTriggers[identifier] = trigger
        triggersToIdentifiers[trigger] = identifier
        internalAdd(trigger)
    }
    
    public func remove(_ trigger: PKTrigger) {
        if let identifier = triggersToIdentifiers[trigger] {
            identifiersToTriggers[identifier] = nil
        }
        triggersToIdentifiers[trigger] = nil
        internalRemove(trigger)
    }
    
    public func getPhysicsTriggerForIdentifier(_ identifier: String) -> PKTrigger? {
        return identifiersToTriggers[identifier]
    }
    
    public func getIdentifierForPhysicsTrigger(_ trigger: PKTrigger) -> String? {
        return triggersToIdentifiers[trigger]
    }
    
    
    
    
    
    private func stepSimulation(_ time: TimeInterval) {
        simulationDelegate?.physicsWorld(self, willSimulateAtTime: time)
        internalStepSimulation(time)
        simulationDelegate?.physicsWorld(self, didSimulateAtTime: time)
    
        if collisionDelegate != nil {
            checkCollisions()
        }
        
        if triggerDelegate != nil {
            checkTriggers()
        }
    }
    
    private func checkCollisions() {
        previousCollisionPairs = collisionPairs
        collisionPairs = [:]
        internalCheckCollisions()
        
        for previousCollisionPair in previousCollisionPairs {
            
            if collisionPairs[previousCollisionPair.key] == nil {
                // No longer colliding
                collisionDelegate?.physicsWorld(self, collisionDidEndAtTime: simulationTime, with: previousCollisionPair.value)
            } else {
                // Continued colliding
                collisionDelegate?.physicsWorld(self, collisionDidContinueAtTime: simulationTime, with: previousCollisionPair.value)
            }
            
        }
            
    }
    
    private func checkTriggers() {
        
        previousTriggerPairs = triggerPairs
        triggerPairs = [:]
        
        for (_, trigger) in identifiersToTriggers {
            
            let collidingRigidBodies = trigger.getCollidingRigidBodies()
            for collidingRigidBody in collidingRigidBodies {
                
                guard
                    let identifierA = getIdentifierForRigidBody(collidingRigidBody),
                    let identifierB = getIdentifierForPhysicsTrigger(trigger)
                    else {
                    return
                }
                
                let combinedIdentifier: String
                if identifierA.hashValue < identifierB.hashValue {
                     combinedIdentifier = identifierA+identifierB
                } else {
                    combinedIdentifier = identifierB+identifierA
                }
                
                if triggerPairs[combinedIdentifier] == nil {
                    let triggerPair = PKTriggerPair(rigidBody: collidingRigidBody, trigger: trigger)
                    triggerPairs[combinedIdentifier] = triggerPair
                    
                    if previousTriggerPairs[combinedIdentifier] == nil {
                        triggerDelegate?.physicsWorld(self, triggerDidBeginAtTime: simulationTime, with: triggerPair)
                    }
                }
                
            }
            
        }
        
        for previousTriggerPair in previousTriggerPairs {
            
            if triggerPairs[previousTriggerPair.key] == nil {
                // No longer colliding
                triggerDelegate?.physicsWorld(self, triggerDidEndAtTime: simulationTime, with: previousTriggerPair.value)
            } else {
                // Continued colliding
                triggerDelegate?.physicsWorld(self, triggerDidContinueAtTime: simulationTime, with: previousTriggerPair.value)
            }
            
        }
    }
    
    public override func internalCollisionDidOccur(_ internalRigidBodyA: PKBRigidBody, localPositionA: SCNVector3, internalRigidBodyB: PKBRigidBody, localPositionB: SCNVector3) {
        
        guard
            let rigidBodyA = internalRigidBodyA as? PKRigidBody,
            let rigidBodyB = internalRigidBodyB as? PKRigidBody else {
            return
        }
        
        guard
            let identifierA = getIdentifierForRigidBody(rigidBodyA),
            let identifierB = getIdentifierForRigidBody(rigidBodyB)
            else {
            return
        }
        
        let combinedIdentifier: String
        if identifierA.hashValue < identifierB.hashValue {
             combinedIdentifier = identifierA+identifierB
        } else {
            combinedIdentifier = identifierB+identifierA
        }
        
        if collisionPairs[combinedIdentifier] == nil {
            let collisionPair = PKCollisionPair(rigidBodyA: rigidBodyA, localPositionA: localPositionA, rigidBodyB: rigidBodyB, localPositionB: localPositionB)
            collisionPairs[combinedIdentifier] = collisionPair
            
            if previousCollisionPairs[combinedIdentifier] == nil {
                collisionDelegate?.physicsWorld(self, collisionDidBeginAtTime: simulationTime, with: collisionPair)
            }
        }
        
    }
    
    public func reset() {
        simulationTime = 0
        for rigidBody in identifiersToRigidBodies.values {
            remove(rigidBody)
        }
        internalReset()
        identifiersToRigidBodies = [:]
        rigidBodiesToIdentifiers = [:]
        collisionPairs = [:]
        previousCollisionPairs = [:]
    }
    
}
