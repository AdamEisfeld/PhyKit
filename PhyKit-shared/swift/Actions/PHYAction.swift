//
//  PHYAction.swift
//  PhyKit
//
//  Created by Adam Eisfeld on 2020-07-03.
//  Copyright © 2020 adameisfeld. All rights reserved.
//
//  Contains OS-Specific Code

import Foundation

/// PHYActions allow you to run custom animations / code on a rigid body's properties over time
public class PHYAction {
    
    public typealias SetupBlock = ((_ rigidBody: PHYRigidBody)->(Any?))
    public typealias ActionBlock = ((_ percent: TimeInterval, _ rigidBody: PHYRigidBody, _ setupInfo: Any?)->())
    
    public var repeatCount: Int = 0
    
    private var setupBlock: SetupBlock? = nil
    private var actionBlock: ActionBlock? = nil
    private var startTime: TimeInterval = 0
    private let duration: TimeInterval
    private var elapsedTime: TimeInterval = 0
    private var displayLink: PHYDisplayLink?
    
    private let rigidBody: PHYRigidBody
    private var playCount: Int = 0
    private var needsSetup: Bool = true
    private var setupInfo: Any? = nil
    
    public init(rigidBody: PHYRigidBody, duration: TimeInterval, setup: SetupBlock? = nil, action: ActionBlock? = nil) {
        self.rigidBody = rigidBody
        self.duration = duration
        self.setupBlock = setup
        self.actionBlock = action
    }
    
    private func clearDisplayLink() {
        displayLink?.stop()
        self.displayLink = nil
    }
    
    public func run() {
        clearDisplayLink()
        
        displayLink = PHYDisplayLink()
        displayLink?.onTick = {
            // TODO: We currently hold a strong reference to ourselves in the onTick block, due to
            // the nature of how actions work. Otherwise nothing would be retaining us and therefor
            // we would be nil in this block. Need to look into better approaches to avoid memory
            // weirdness in the future (perhaps by adding an action to a rigid body, so that the
            // rigid body retains the action, instead of just arbitrarily calling start() on the
            // action).
            self.drawTick()
        }
        
        startTime = CACurrentMediaTime()
        displayLink?.start()
    }
    
    public func stop() {
        clearDisplayLink()
    }
    
    @objc private func drawTick() {
        
        if needsSetup {
            startTime = CACurrentMediaTime()
            setupInfo = setupBlock?(rigidBody)
            needsSetup = false
        }
        
        elapsedTime = CACurrentMediaTime() - startTime
        
        var ratio = elapsedTime / duration
        
        if ratio >= 1 {
            
            ratio = 1
            
            playCount += 1
            
            if repeatCount > -1, playCount > repeatCount {
                clearDisplayLink()
            } else {
                needsSetup = true
            }
            
        }
        
        actionBlock?(ratio, rigidBody, setupInfo)
        
    }
    
}
