//
//  PKAction.swift
//  PhysicsKit
//
//  Created by Adam Eisfeld on 2020-07-03.
//  Copyright © 2020 adameisfeld. All rights reserved.
//

import Foundation

/// PKActions allow you to run custom animations / code on a rigid body's properties over time
public class PKAction {
    
    public typealias SetupBlock = ((_ rigidBody: PKRigidBody)->(Any?))
    public typealias ActionBlock = ((_ percent: TimeInterval, _ rigidBody: PKRigidBody, _ setupInfo: Any?)->())
    
    public var repeatCount: Int = 0
    
    private var setupBlock: SetupBlock? = nil
    private var actionBlock: ActionBlock? = nil
    private var startTime: TimeInterval = 0
    private let duration: TimeInterval
    private var elapsedTime: TimeInterval = 0
    private var displayLink: CADisplayLink?
    private let rigidBody: PKRigidBody
    private var playCount: Int = 0
    private var needsSetup: Bool = true
    private var setupInfo: Any? = nil
    
    public init(rigidBody: PKRigidBody, duration: TimeInterval, setup: SetupBlock? = nil, action: ActionBlock? = nil) {
        self.rigidBody = rigidBody
        self.duration = duration
        self.setupBlock = setup
        self.actionBlock = action
    }
    
    private func clearDisplayLink() {
        displayLink?.remove(from: .current, forMode: .common)
        displayLink?.invalidate()
        displayLink = nil
    }
    
    public func run() {
        clearDisplayLink()
        displayLink = CADisplayLink(target: self, selector: #selector(drawTick))
        displayLink?.add(to: .current, forMode: .common)
        startTime = CACurrentMediaTime()
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
