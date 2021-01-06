//
//  BridgeUserInterface.swift
//  ScratchPad (iOS)
//
//  Created by Adam Eisfeld on 2021-01-06.
//

import Foundation
import UIKit
import SwiftUI

/**
 
 The following code has nothing to do with PhyKit. It is just a quick solution for
 reverting to UIKit/UIViewControllers instead of using SwiftUI.
 
 */

public struct ContainerViewUIKit: UIViewControllerRepresentable {
    
    public typealias UIViewControllerType = BridgeViewController
    
    public func makeUIViewController(context: Context) -> BridgeViewController {
        return ScratchPadViewController()
    }
    
    public func updateUIViewController(_ uiViewController: BridgeViewController, context: Context) {
    }
    
}

public typealias BridgeViewController = UIViewController
public typealias BridgeView = UIView
public typealias BridgeColor = UIColor
public typealias BridgeContainerView = ContainerViewUIKit
