//
//  OverlayWindowController.swift
//  CandleView
//
//  Created by liam on 19/8/2025.
//

import SwiftUI

class OverlayWindowController: NSWindowController {
    convenience init(viewModel: OverlayViewModel) {
        let hosting = NSHostingController(rootView: OverlayView(viewModel: viewModel))
        let panel = NSPanel(
            contentRect: NSRect(x: 100, y: 100, width: 250, height: 180),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        panel.isOpaque = true
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.isMovableByWindowBackground = true
        panel.isFloatingPanel = true
        panel.level = .statusBar
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.isMovableByWindowBackground = true
        panel.contentViewController = hosting
        
        self.init(window: panel)
    }
}
