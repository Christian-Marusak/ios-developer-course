//
//  HostingControllerHidesTabBar.swift
//  Course App
//
//  Created by Christián on 22/06/2024.
//

import SwiftUI

class HostingControllerHidesTabBar<Content: View>: UIHostingController<Content> {
    
    private var hideBottomBar: Bool
    
    init(rootView: Content, hideBottomBar: Bool) {
        self.hideBottomBar = hideBottomBar
        super.init(rootView: rootView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        get {
            hideBottomBar
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }
}
