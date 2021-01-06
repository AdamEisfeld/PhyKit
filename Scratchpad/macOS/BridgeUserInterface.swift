//
//  BridgeUserInterface.swift
//  ScratchPad (macOS)
//
//  Created by Adam Eisfeld on 2021-01-06.
//

import Foundation
import AppKit
import SwiftUI

/**
 
 The following code has nothing to do with PhyKit. It is just a quick solution for
 reverting to AppKit/NSViewControllers instead of using SwiftUI.
 
 */

public struct ContainerViewUIKit: NSViewControllerRepresentable {
    
    public typealias NSViewControllerType = BridgeViewController
    
    public func makeNSViewController(context: Context) -> BridgeViewController {
        return ScratchPadViewController()
    }
    
    public func updateNSViewController(_ uiViewController: BridgeViewController, context: Context) {
    }
    
}

public typealias BridgeViewController = NSViewController
public typealias BridgeView = NSView
public typealias BridgeColor = NSColor
public typealias BridgeContainerView = ContainerViewUIKit
