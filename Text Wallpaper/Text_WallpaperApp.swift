//
//  Glyph_Wallpaper_GeneratorApp.swift
//  Glyph Wallpaper Generator
//
//  Created by Valentine Briese on 2024-11-04.
//

import SwiftUI

class Text_WallpaperAppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

@main
struct Text_WallpaperApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: Text_WallpaperAppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
