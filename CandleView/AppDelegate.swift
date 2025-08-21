//
//  AppDelegate.swift
//  CandleView
//
//  Created by liam on 19/8/2025.
//

import Cocoa
import SwiftUI

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    var overlayController: OverlayWindowController?
    @Published private(set) var sharedViewModel = OverlayViewModel()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        overlayController = OverlayWindowController(viewModel: sharedViewModel)
        overlayController?.showWindow(nil)
    }
}
