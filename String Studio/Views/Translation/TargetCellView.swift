//
//  TargetCellView.swift
//  String Studio
//
//  Created by Licardo on 2025/10/12.
//

import Defaults
import SwiftUI

/// 目标翻译单元格视图
struct TargetCellView: View {
    let entry: TableEntry
    @Binding var document: StringStudioDocument
    let selectedLanguage: String

    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    @State private var isTranslating: Bool = false
    @State private var translationError: String?
    @Default(.aiTranslationSettings) var aiTranslationSettings

    /// 检查是否为源语言
    private var isSourceLanguage: Bool {
        return selectedLanguage == document.xcstrings.sourceLanguage
    }

    var body: some View {
        HStack {
            TextEditor(text: $text)
                .scrollIndicators(.never)
                .focused($isFocused)
                .onAppear {
                    text = entry.targetValue
                }
                .onChange(of: isFocused) { _, focused in
                    if !focused {
                        saveChanges()
                    }
                }
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 0.2)
                )

            if aiTranslationSettings.isEnabled {
                Button {
                    Task {
                        await translateText()
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
                .help(translationError ?? "AI Translate")
                .foregroundColor(translationError != nil ? .red : nil)
            }
        }
        .disabled(isSourceLanguage || entry.key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || entry.defaultValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || entry.state == .dontTranslate)
    }

    /// 保存更改
    private func saveChanges() {
        // 检查值是否真的改变了，避免不必要的更新
        let currentValue = document.xcstrings.strings[entry.key]?.localizations?[selectedLanguage]?.stringUnit?.value ?? ""
        guard currentValue != text else { return }

        var updatedStrings = document.xcstrings.strings

        if var stringEntry = updatedStrings[entry.key] {
            if stringEntry.localizations == nil {
                stringEntry.localizations = [:]
            }

            stringEntry.localizations?[selectedLanguage] = Localization(
                stringUnit: StringUnit(
                    state: text.isEmpty ? .new : .translated,
                    value: text
                )
            )

            updatedStrings[entry.key] = stringEntry
        } else {
            let newEntry = StringEntry(
                localizations: [
                    selectedLanguage: Localization(
                        stringUnit: StringUnit(
                            state: text.isEmpty ? .new : .translated,
                            value: text
                        )
                    )
                ]
            )
            updatedStrings[entry.key] = newEntry
        }

        document.xcstrings.strings = updatedStrings
    }

    /// AI翻译功能
    private func translateText() async {
        guard !isSourceLanguage else { return }

        // 检查是否有实际内容需要翻译
        let trimmedText = entry.defaultValue.trimmingCharacters(in: .whitespacesAndNewlines)
        print("🔍 Debug - entry.defaultValue: '\(entry.defaultValue)'")
        print("🔍 Debug - trimmedText: '\(trimmedText)'")
        print("🔍 Debug - isEmpty: \(trimmedText.isEmpty)")
        print("🔍 Debug - characterCount: \(trimmedText.count)")

        guard !trimmedText.isEmpty else {
            translationError = "No text to translate"
            return
        }

        let settings = Defaults[.aiTranslationSettings]
        guard settings.isEnabled else {
            translationError = "AI translation is disabled"
            return
        }

        guard !settings.apiURL.isEmpty, !settings.apiKey.isEmpty, !settings.model.isEmpty else {
            translationError = "Translation settings incomplete"
            return
        }

        isTranslating = true
        translationError = nil

        do {
            let translatedText = try await AITranslationService.shared.translate(
                source: document.xcstrings.sourceLanguage,
                target: selectedLanguage,
                text: trimmedText
            )

            await MainActor.run {
                text = translatedText
                saveChanges()
            }

        } catch {
            await MainActor.run {
                translationError = error.localizedDescription
            }
        }

        await MainActor.run {
            isTranslating = false
        }
    }
}
