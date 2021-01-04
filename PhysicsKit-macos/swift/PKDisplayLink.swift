//
//  PKDisplayLink.swift
//  PhysicsKit
//
//  Created by Adam Eisfeld on 2020-12-31.
//

import Foundation
import CoreVideo

public class PKDisplayLink {
    
    public var onTick: (()->())? = nil
    
    private var displayLink: CVDisplayLink?
    
    public func start() {
        // Ensure we're stopped
        stop()

        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        guard let displayLink = displayLink else {
            fatalError("Unable to create CVDisplayLink")
        }
        
        let displayLinkOutputCallback: CVDisplayLinkOutputCallback = {(displayLink: CVDisplayLink, inNow: UnsafePointer<CVTimeStamp>, inOutputTime: UnsafePointer<CVTimeStamp>, flagsIn: CVOptionFlags, flagsOut: UnsafeMutablePointer<CVOptionFlags>, displayLinkContext: UnsafeMutableRawPointer?) -> CVReturn in
        let action = unsafeBitCast(displayLinkContext, to: PKDisplayLink.self)
        action.tick()
            return kCVReturnSuccess
        }
        CVDisplayLinkSetOutputCallback(displayLink, displayLinkOutputCallback, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
        CVDisplayLinkStart(displayLink)

    }
    
    public func stop() {
        guard let displayLink = displayLink else {
            return
        }

        CVDisplayLinkStop(displayLink)

        self.displayLink = nil
    }
    
    @objc private func tick() {
        onTick?()
    }
    
}
