//
//  Glyph_Wallpaper_GeneratorApp.swift
//  Glyph Wallpaper Generator
//
//  Created by Valentine Briese on 2024-11-04.
//

import SwiftUI

class Glyph_Wallpaper_GeneratorAppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

@main
struct Glyph_Wallpaper_GeneratorApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: Glyph_Wallpaper_GeneratorAppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
