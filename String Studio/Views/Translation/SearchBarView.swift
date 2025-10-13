//
//  SearchBarView.swift
//  String Studio
//
//  Created by Licardo on 2025/10/12.
//

import Defaults
import SwiftUI

/// 搜索栏视图
struct SearchBarView: View {
    @Binding var text: String
    let onBatchTranslate: () async -> Void

    @State private var isTranslating: Bool = false
    @State private var translationError: String?
    @Default(.aiTranslationSettings) var aiTranslationSettings

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)

            TextField("Search Key、Localization or Comment...", text: $text)
                .textFieldStyle(.plain)

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }

            if aiTranslationSettings.isEnabled {
                Button {
                    Task {
                        isTranslating = true
                        translationError = nil
                        await onBatchTranslate()
                        isTranslating = false
                    }
                } label: {
                    if isTranslating {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Image(systemName: "apple.intelligence")
                    }
                }
                .disabled(isTranslating)
                .help(translationError ?? "AI Translate All")
                .foregroundColor(translationError != nil ? .red : nil)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(Color(NSColor.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
