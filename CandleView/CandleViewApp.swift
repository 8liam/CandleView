//
//  CandleViewApp.swift
//  CandleView
//
//  Created by liam on 19/8/2025.
//

import SwiftUI

@main
struct MemecoinOverlayApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: appDelegate.sharedViewModel)
        }
    }
}
