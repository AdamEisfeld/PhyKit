//
//  PKPhysicsWorld.swift
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-10.
//  Copyright © 2020 adam. All rights reserved.
//

import Foundation
import SceneKit

/**
 PhysicsWorlds are responsible for running the actual bullet simulation and managing which
 physics bodies are attached to the world.
 */
public class PKPhysicsWorld: PKBPhysicsWorld {
    
    // MARK: Public Properties
    
    /// An optional delegate for receiving callbacks as the simulation steps forward in time
    public weak var simulationDelegate: PKPhysicsWorldSimulationDelegate?
    
    /// An optional delegate for receiving callbacks as rigid bodies collide in the simulation
    public weak var collisionDelegate: PKPhysicsWorldCollisionDelegate?
    
    /// An optional delegate for receiving callbacks as rigid bodies enter / exit trigger zones
    public weak var triggerDelegate: PKPhysicsWorldTriggerDelegate?
    
    /// The current time of the simulation. Increasing this value will cause the simulation to step forward in time.
    public var simulationTime: TimeInterval = 0 {
        didSet {
            stepSimulation(simulationTime)
        }
    }
    
    // MARK: Private Properties

    private var rigidBodies: Set<PKRigidBody> = []
    private var triggers: Set<PKTrigger> = []

    private var collisionPairs: [String : PKCollisionPair] = [:]
    private var previousCollisionPairs: [String : PKCollisionPair] = [:]
    
    private var triggerPairs: [String : PKTriggerPair] = [:]
    private var previousTriggerPairs: [String : PKTriggerPair] = [:]
    
    // MARK: Public Functions - Rigid Bodies
    
    /// Adds a rigid body to the simulation
    /// - Parameters:
    ///   - rigidBody: The rigid body to add
    public func add(_ rigidBody: PKRigidBody) {
        rigidBodies.insert(rigidBody)
        internalAdd(rigidBody)
    }
    
    /// Removes a rigid body from the simulation
    /// - Parameter rigidBody: The rigid body to remove from the simulation
    public func remove(_ rigidBody: PKRigidBody) {
        rigidBodies.remove(rigidBody)
        internalRemove(rigidBody)
    }

    // MARK: Public Functions - Triggers
    
    /// Adds a trigger to the simulation
    /// - Parameters:
    ///   - trigger: The trigger to add to the simulation
    public func add(_ trigger: PKTrigger) {
        triggers.insert(trigger)
        internalAdd(trigger)
    }
    
    /// Removes a trigger from the simulation
    /// - Parameter trigger: The trigger to remove from the simulation
    public func remove(_ trigger: PKTrigger) {
        triggers.remove(trigger)
        internalRemove(trigger)
    }
    
    // MARK: Public Functions - State
    
    public func reset() {
        simulationTime = 0
        for rigidBody in rigidBodies {
            remove(rigidBody)
        }
        for trigger in triggers {
            remove(trigger)
        }
        internalReset()
        rigidBodies = []
        triggers = []
        collisionPairs = [:]
        previousCollisionPairs = [:]
    }

    // MARK: Private Functions
    
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
        
        for trigger in triggers {
            
            let collidingRigidBodies = trigger.getCollidingRigidBodies()
            for collidingRigidBody in collidingRigidBodies {
                
                let identifierA = collidingRigidBody.uuid
                let identifierB = trigger.uuid
                
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
    
    public override func internalCollisionDidOccur(_ internalRigidBodyA: PKBRigidBody, localPositionA: PKVector3, internalRigidBodyB: PKBRigidBody, localPositionB: PKVector3) {
        
        guard
            let rigidBodyA = internalRigidBodyA as? PKRigidBody,
            let rigidBodyB = internalRigidBodyB as? PKRigidBody else {
            return
        }
        
        let identifierA = rigidBodyA.uuid
        let identifierB = rigidBodyB.uuid
        
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
    
}
