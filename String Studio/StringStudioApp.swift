//
//  StringStudioApp.swift
//  String Studio
//
//  Created by Licardo on 2025/10/12.
//

import Defaults
import SwiftUI

/// String Studio 主应用入口
@main
struct StringStudioApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: StringStudioDocument()) { configuration in
            MainContentView(document: configuration.$document)
        }
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
        .defaultPosition(.center)
        .defaultLaunchBehavior(.presented)
        .defaultSize(width: 1300, height: 800)

        Settings {
            SettingsView()
        }
    }
}
