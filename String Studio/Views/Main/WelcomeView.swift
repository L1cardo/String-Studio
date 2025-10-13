//
//  WelcomeView.swift
//  String Studio
//
//  Created by Licardo on 2025/10/12.
//

import SwiftUI

/// 欢迎视图
struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("Choose a language")
                .font(.title)
                .fontWeight(.bold)

            Text("Select a language from the left sidebar to start the translation.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
