//
//  PKDisplayLink.swift
//  PhysicsKit
//
//  Created by Adam Eisfeld on 2020-12-31.
//

import Foundation

// A macos/ios display link backed by a CADisplayLink on iOS and a CVDisplayLink on macos
public class PKDisplayLink {
    
    public var onTick: (()->())? = nil
    
    private var displayLink: CADisplayLink?
    
    public func start() {
        // Ensure we're stopped
        stop()

        displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink?.add(to: .current, forMode: .common)
        
    }
    
    public func stop() {
        guard let displayLink = displayLink else {
            return
        }
        
        displayLink.remove(from: .current, forMode: .common)
        displayLink.invalidate()

        self.displayLink = nil
    }
    
    @objc private func tick() {
        onTick?()
    }
    
}
